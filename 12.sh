#!/usr/bin/env bash

set -e # Exit on error

echo "in 12.sh"
echo "Purpose: agents and models"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

# Setup params

llama-server="8080"
lem-mcp-server="7890"
cl-mcp-server="12345"
model-name="openai_gpt-oss-20b-Q4_K_M"


# File locations:
# ~/.config/lisp-dev/env              # Environment variables
# ~/.config/lisp-dev/startup.sh       # Service startup
# ~/.config/opencode/opencode.json    # OpenCode configuration
# ~/.clmcprc                          # cl-mcp startup
# ~/quicklisp/local-projects/cl-mcp/  # cl-mcp source
# ~/.models/gpt-oss-20b-Q4_K_M.gguf  # Model file (11.6GB)
# .opencode/AGENTS.md                 # Project template

# Inference Server
guix install llamacpp


# &&& make function # Start server command
# auto fitting -ngl, -t, and -c are NOT specified
# -ngl 50
# -t 32
# -c 131072
# --threads-batch 16
./llama-server \
  -m models/openai_gpt-oss-20b-Q4_K_M.gguf \
  --host 127.0.0.1 \
  --port 8080 \
  -ctk q6_K \
  -ctv q6_K \
  -fa \
  --numa distribute \
  -b 2048 \
  -ub 2048 \
  --parallel 2 \
  --cont-batching \
  --cache-prompt \
  --metrics \
  --jinja

# Model

# GLM-4.7-Flash
# Qwen2.5-Coder 32B
# Gpt oss 20b

mkdir -p ~/.cache/llama.cpp/
llama-cli --hf-repo ggml-org/gpt-oss-20b-GGUF --hf-file gpt-oss-20b-Q4_K_M.gguf --version
# => ~/.cache/llama.cpp/

# Agent

# install Opencode
curl -fsSL https://opencode.ai/install | bash

# AGENTS.md template below

# configuration
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "providers": {
    "local": {
      "apiKey": "not-needed",
      "baseUrl": "http://localhost:8080/v1",
      "models": {
        "gpt-oss-20b": {
          "id": "gpt-oss-20b",
          "name": "GPT-OSS 20B",
          "maxTokens": 128000,
          "contextWindow": 128000
        }
      }
    }
  },
  "agents": {
    "coder": {
      "model": "local/gpt-oss-20b",
      "maxTokens": 8192
    }
  }
}
EOF

# &&& start up function
# Add OpenCode environment variables
cat >> ~/.config/lisp-dev/env << 'EOF'

# OpenCode configuration
export OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
EOF

# cl-mcp

# Clone cl-mcp repository
cd ~/common-lisp/
git clone https://github.com/cl-ai-project/cl-mcp.git

# Load dependencies
sbcl --eval '(asdf:load-system :cl-mcp)' --quit

# Register cl-mcp server with OpenCode
mkdir -p ~/.config/opencode/mcp
cat > ~/.config/opencode/mcp/cl-lisp.json << 'EOF'

{
  "name": "cl-lisp",
  "transport": "stdio",
  "command": "python3",
  "args": [
    "~/quicklisp/local-projects/cl-mcp/scripts/stdio_tcp_bridge.py",
    "--host", "127.0.0.1",
    "--port", "12345"
  ]
}

EOF

# Create startup configuration
cat > ~/.clmcprc << 'EOF'

;;; cl-mcp server startup configuration
(asdf:load-system :cl-mcp :silent t)

(defun start-cl-mcp-server ()
  "Start the cl-mcp TCP server on port 12345"
  (cl-mcp:start-tcp-server-thread :port 12345)
  (format t "~%cl-mcp server started on port 12345~%")
  (force-output))

(start-cl-mcp-server)

;; maybe Keep process alive
;; (loop (sleep 60))

EOF

# lem-mcp

# Source environment
source ~/.config/lisp-dev/env

# Register Lem's MCP server with OpenCode
mkdir -p ~/.config/opencode/mcp
cat > ~/.config/opencode/mcp/lem.json << 'EOF'

{
  "name": "lem",
  "transport": "http",
  "url": "http://localhost:7890/mcp"
}

EOF

# *** Running environment
cat >> ~/.config/lisp-dev/env << 'EOF'

# llama.cpp server configuration
export LLAMA_SERVER_HOST="http://localhost:8080"

# cl-mcp configuration
export MCP_LOG_LEVEL="info"

EOF

# Startup

# STARTUP SCRIPT
touch ~/.config/lisp-dev/startup.sh
chmod +x ~/.config/lisp-dev/startup.sh

cat > ~/.config/lisp-dev/startup.sh << 'EOF'

#!/usr/bin/env bash
# Startup script for agentic Common Lisp environment

# Source environment
# &&& move all to here and add directly
source ~/.config/lisp-dev/env

# Start llama.cpp server
if ! pgrep -f "llama-server" > /dev/null; then
    nohup llama-server \
        -m "$GPT_OSS_MODEL" \
        --host 0.0.0.0 \
        --port 8080 \
        --ctx-size 128000 \
        --n-predict -1 \
        > ~/.llama-server.log 2>&1 &
    echo "Started llama-server (PID: $!)"
fi

# Start cl-mcp server
if ! pgrep -f "cl-mcp" > /dev/null; then
    nohup sbcl --load ~/.clmcprc > ~/.cl-mcp.log 2>&1 &
    echo "Started cl-mcp server (PID: $!)"
fi

# Wait for services
sleep 3

# Verify
curl -s http://localhost:8080/health > /dev/null && echo "✓ llama-server ready"
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{}}' | nc -w1 localhost 12345 > /dev/null 2>&1 && echo "✓ cl-mcp ready"

echo ""
echo "Services started. Now:"
echo "1. Start Lem: lem"
echo "2. In Lem: M-x mcp-server-start"
echo "3. Use OpenCode: cd ~/project && opencode"

EOF

# AGENTS.md
# PROJECT INSTRUCTIONS TEMPLATE
mkdir -p .opencode
cat > .opencode/AGENTS.md << 'EOF'
# Common Lisp Development Environment

## System Context
- Running in Podman container
- SBCL + Quicklisp
- Lem editor (Common Lisp IDE)
- Local LLM: llama.cpp serving gpt-oss-20b (Apache 2.0)
- MCP Servers: Lem (HTTP:7890) + cl-mcp (TCP:12345)

## MCP Tools

### Lem MCP (http://localhost:7890/mcp)
Direct editor interaction:
- Read/edit buffers open in Lem
- Get current file/selection
- Query editor state

### cl-mcp (TCP:12345)
Common Lisp operations:
- **repl-eval**: Evaluate Lisp forms
- **fs-read-file**: Read files with Lisp-aware collapsing
- **fs-write-file**: Write files (project root only)
- **code-find**: Locate symbol definitions
- **code-describe**: Get symbol documentation
- **fs-list-directory**: List directory contents

## Workflow

Prefer MCP tools over bash for Lisp operations:
```
Good: Use cl-lisp/repl-eval with code: "(+ 1 2 3)"
Bad:  Bash(sbcl --eval "(+ 1 2 3)")
```

## Common Lisp Standards
- Use kebab-case: `my-function-name`
- 2-space indentation
- Docstrings for public APIs
- Package definitions in package.lisp

## Constraints
- No systemd (container)
- No sudo access
- No external network without permission
- Changes only in project directory

## Project Structure
```
project/
├── project.asd
├── src/
│   ├── package.lisp
│   └── main.lisp
└── tests/
    └── tests.lisp
```

## Common Tasks
- Load: `(ql:quickload :system)`
- Test: `(asdf:test-system :system)`
- Find: Use code-find tool
- Eval: Use repl-eval tool
EOF
