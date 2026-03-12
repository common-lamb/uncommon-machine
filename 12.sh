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

# configure environment
ollama_port=11434
cl_mcp_port=3000
lem_mcp_port=7890

OLLAMAHOST=http://localhost:${ollama_port}
OLLAMA_CONTEXT_LENGTH=64000

model_name="qwen3.5:0.8b"
# hf_model="unsloth/Qwen3.5-35B-A3B-GGUF" # top

cat << EOF >> ~/.bashrc

# agent settings
export ollama_port=${ollama_port}
export cl_mcp_port=${cl_mcp_port}
export lem_mcp_port=${lem_mcp_port}

exportOLLAMAHOST=${OLLAMAHOST}
export OLLAMA_CONTEXT_LENGTH=${OLLAMA_CONTEXT_LENGTH}

export model_name=${model_name}

EOF

# install ollama
curl -fsSL https://ollama.com/install.sh | sh

# dl model
ollama serve & # start server
sleep 15
ollama pull ${model_name}
# ollama pull hf.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive:Q4_K_M
# ollama run hf.co/HauhauCS/Qwen3.5-9B-Uncensored-HauhauCS-Aggressive:Q4_K_M

# # install Opencode
curl -fsSL https://opencode.ai/install | bash
cd ~/.uncommon-dotfiles
stow opencode

# install hermes
cd ~ && mkdir -p temp && cd temp
curl -fsSL -o install.sh https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh
chmod +x install.sh
./install.sh --skip-setup
cd ~ && rm -r temp

# CL-MCP
# Clone cl-mcp repository
cd ~/common-lisp/
git clone https://github.com/cl-ai-project/cl-mcp.git
cd ~
sbcl --eval '(asdf:load-system :cl-mcp)' --quit
# cl-mcp startup is in lem init as (cl-mcp-server-start)

# LEM-MCP
# mpc is built in
# startup is in lem init as (mcp-server-start)

# configure opencode
cd ~/.uncommon-dotfiles
stow opencode

# configure hermes model
mkdir -p ~/.hermes
cat > ~/.hermes/.env << EOF

OPENAI_BASE_URL=http://localhost:${ollama_port}/v1
OPENAI_API_KEY=any-non-nil-str
LLM_MODEL=${model_name}

EOF

# configure hermes mcp
cat > ~/.hermes/config.yaml << EOF

mcp_servers:
  common_lisp:
    url: "http://localhost:${cl_mcp_port}/mcp"

EOF

# STARTUP

cat >> ~/.bashrc << EOF

agents-start() {
    # export MCP_PROJECT_ROOT=\$(pwd) # set cl-mcp pwd
    ollama serve &

}

check-mcp() {
    curl -X POST http://localhost:${cl_mcp_port}/mcp \
         -H "Content-Type: application-json" \
         -d '{"jsonrpc":"2.0", "method":"initialize", "params":{}, "id":1}'
    # -d '{"jsonrpc":"2.0", "method":"tools/list", "params":{}, "id":2}'
}

EOF
