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

# SELECT MODEL

# GLM-4.7-Flash
# hf_model="ggml-org/gpt-oss-20b-GGUF"
# hf_model="unsloth/Qwen3.5-35B-A3B-GGUF" # top
hf_model="unsloth/Qwen3.5-2B-GGUF" # small test

# SETUP PARAMS

llama_port=8080
cl_mcp_port=3000
lem_mcp_port=7890
LLAMA_SERVER_HOST="http://localhost:${llama_port}"

cat << EOF >> ~/.bashrc

# agent settings
export llama_port=${llama_port}
export cl_mcp_port=${cl_mcp_port}
export lem_mcp_port=${lem_mcp_port}
export LLAMA_SERVER_HOST="http://localhost:${llama_port}"
export hf_model=${hf_model}

EOF

# INFERENCE SERVER
guix install llama-cpp

# -c 131072
# -c,    --ctx-size N                     size of the prompt context (default: 0, 0 = loaded from model)
#                                         (env: LLAMA_ARG_CTX_SIZE)
# -ctk,  --cache-type-k TYPE              KV cache data type for K
#                                         allowed values: f32, f16, bf16, q8_0, q4_0, q4_1, iq4_nl, q5_0, q5_1
#                                         (default: f16)
# -ngl,  --gpu-layers, --n-gpu-layers N   max. number of layers to store in VRAM, either an exact number,
#                                         'auto', or 'all' (default: auto)
# -ncmoe, --n-cpu-moe N                   keep the Mixture of Experts (MoE) weights of the first N layers in the
#                                         CPU
#                                         (env: LLAMA_ARG_N_CPU_MOE)
# --threads 32
# --threads-batch 16

llama-server-start() {
    llama-server \
        -hf ${hf_model} \
        --port ${llama_port} \
        --ctx-size 0 \
        --n-cpu-moe 16 \
        -b 2048 \
        -ub 2048 \
        --numa distribute \
        --parallel 1 \
        --jinja
}

cat << EOF >> ~/.bashrc

llama-server-start() {
    llama-server \
        -hf ${hf_model} \
        --port ${llama_port} \
        --ctx-size 0 \
        --n-cpu-moe 16 \
        -b 2048 \
        -ub 2048 \
        --numa distribute \
        --parallel 1 \
        --jinja
}

EOF

# MODEL

# download model
echo "downloading: ${hf_model}"
llama-cli -hf ${hf_model} --version
# loaded to: ~/.cache/llama.cpp/

# AGENT

# install Opencode
curl -fsSL https://opencode.ai/install | bash
cd ~/.uncommon-dotfiles
stow opencode

# CL-MCP
# Clone cl-mcp repository
cd ~/common-lisp/
git clone https://github.com/cl-ai-project/cl-mcp.git

cd ~
sbcl --eval '(asdf:load-system :cl-mcp)' --quit

# cl-mcp startup is in lem init as (cl-mcp-server-start)

# LEM-MCP
# mpc is built in
# startup is in lemrc as (mcp-server-start)

# STARTUP

cat >> ~/.bashrc << EOF

agents-start() {

    # Start llama.cpp server
    if ! curl -s http://localhost:${llama_port}/health > /dev/null; then
        llama-server-start
    fi

    # Wait for services
    sleep 3
    # Verify llama
    curl -s http://localhost:${llama_port}/health > /dev/null && echo "llama-server ready"

    echo ""
    echo "we assume: nav to project"
    echo "start lem: lem"
    # &&& set lem-mcp pwd
    echo "lem will start sbcl"
    MCP_PROJECT_ROOT=$(pwd) # &&& set cl-mcp pwd
    echo "run /connect to configure model"
    echo "run /init to create AGENTS.md"
    echo "starting opencode: opencode"
    opencode
}

EOF
