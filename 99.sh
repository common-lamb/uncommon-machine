#!/usr/bin/env bash

set -e # Exit on error

echo "in 99.sh"
echo "Purpose: patches"

# container does not source .profile or .bashrc
source ~/.bashrc

# fresh dots
cd ~/.uncommon-dotfiles
git fetch
git pull

# ======================================
# 00 base os pull, os update
# ======================================
# ======================================
# 01 guix I test daemon, pull
# ======================================
# ======================================
# 02 guix II, start daemon
# ======================================
# ======================================
# 03 security encryption dotfiles secrets
# ======================================

# &&& spoof all keys needed by dotfiles

# ======================================
# 04 emacs, locale, emacs supporting packages, spacemacs
# ======================================

# &&& spacemacs buffer.el corrupting
# to change emacs in patches stop and restart to rerun initialization
# emacsclient -e '(kill-emacs)'
# yes | emacs --daemon

# ======================================
# 05 terminal
# ======================================
# ======================================
# 06 git, workflows, disposable environments, data languages and containers,
# ======================================

# &&& install apptainer

# ======================================
# 07 lisp I, SBCL, quicklisp, ultralisp, ocicl, shl
# ======================================

# &&& lower ultralisp priority
# (ql-dist:all-dists)
# (ql-dist:preference (first (ql-dist:all-dists))) ;the universal time of setting
# (ql-dist:preference (second (ql-dist:all-dists)))

# (setf (ql-dist:preference (first (ql-dist:all-dists)))
#       (get-universal-time))

# (loop with dists = (sort (copy-list (ql-dist:enabled-dists))
#                          #'>
#                          :key #'ql-dist:preference)
#       for dist in dists
#       do (format t "* ~A (~A)~%"
#                  (ql-dist:name dist)
#                  (ql-dist:version dist)))

# ======================================
# 08 lisp II Lish, lem, nyxt, stumpw
# ======================================

git clone https://github.com/fukamachi/.lem ~/.lem

mkdir -p ~/common-lisp && cd ~/common-lisp
git clone https://github.com/fukamachi/lem-vi-sexp.git
# &&& pick up and push fukamachi's config
# &&& remove the clone line activate the stow line
# cd ~/.uncommon-dotfiles
# stow lem

# &&& nyxt
# timed out
# guix install nyxt emacs-nyxt
# cd ~/.uncommon-dotfiles
# stow nyxt


# &&& stump
# symlink nice things from contrib to modules
# cd ~/.stumpwm.d/contrib ln -s &&& ../modules/&&&

# ======================================
# 09 network
# ======================================

# &&& Email
# https://jf-parent.github.io/blog/2020/01/01/email-from-spacemacs-my-mu4e-org-msg-offlineimap-setup/

# &&& ipfs private network
# &&& tailscale vpn

# ======================================
# 10 data storage redundancy and access
# ======================================

# # setup dropbox
# rclone config #make new @ db
# rclone lsd db:
# mkdir -p ~/db/1
# # start
# rclone mount db:1 ~/db/1 --vfs-cache-mode full &
# # stop
# cd ~ && fusermount -u ~/db/1

# ======================================
# 11 graphics and styling
# ======================================

# &&& set XTERM etc
# &&& rundle ridge desktop
# &&& lunaria light palette

# ======================================
# 12 agents and models
# ======================================

llama_port="8080"
lem_mcp_port="7890"
cl_mcp_port="12345"
hf_model="ggml-org/gpt-oss-20b-GGUF"

cat >> ~/.sbclrc << EOF

;;; cl-mcp server startup configuration
(asdf:load-system :cl-mcp)

(defun serve-cl-mcp ()
  "Start the cl-mcp TCP server"
  (cl-mcp:start-tcp-server-thread :port (uiop:getenv "cl_mcp_port"))
  (format t "~%cl-mcp server started on (uiop:getenv "cl_mcp_port")~%")
  (force-output))

(serve-cl-mcp)

EOF

cat >> ~/.lemrc&&& << EOF
;; lem-mcp server startup
(mcp-server-start)
EOF

# configure open code
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json << EOF
{
  "providers": {
    "local": {
      "apiKey": "not-needed",
      "baseUrl": "http://localhost:${llama_port}/v1",
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

cat > ~/.config/opencode/mcp/lem.json << 'EOF'

{
  "name": "lem",
  "transport": "http",
  "url": "http://localhost:7890/mcp"
}

EOF



# AGENTS.md
# PROJECT INSTRUCTIONS TEMPLATE
mkdir -p .opencode
cat > .opencode/AGENTSTEMPLATE.md << 'EOF'
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


# ======================================
# &&& Writing
# ======================================
# &&& Citation
# &&& Latex, guix install texlive
# &&& Mermaid via snap
# &&& install language tool

#user add
#user, password
#copy root home


# decoupling:  compute, setup, configuration, secrets, data
