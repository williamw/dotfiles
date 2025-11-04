#!/bin/bash

if [ -z "$HF_TOKEN" ]; then
    HF_TOKEN=$(op item get "Hugging Face" --fields credential --reveal 2>/dev/null)
fi

if [ -z "$HF_TOKEN" ]; then
    echo "⚠️  Warning: Failed to retrieve HF_TOKEN from 1Password. Make sure you're authenticated with 'op signin'"
fi

MODEL_CLASS_1="OpenGVLab/InternVL3-14B-Instruct"
MODEL_CLASS_2="Qwen/Qwen2.5-VL-7B-Instruct"
MODEL_CLASS_3="HuggingFaceTB/SmolLM2-1.7B-Instruct"
MODEL_Q_WEIGHTS="HuggingFaceTB/SmolLM2-1.7B-Instruct-GGUF/smollm2-1.7b-instruct-q4_k_m.gguf"

if command -v nvidia-smi &> /dev/null; then
    echo "Detected NVIDIA toolchain"
    compute_cap=$(nvidia-smi --query-gpu compute_cap --format=csv,noheader)
    echo "CUDA compute capacity: $compute_cap"
    if (( $(printf "%.0f" "$compute_cap") >= 9 )); then
        MAX_MODEL=$MODEL_CLASS_1
    else
        MAX_MODEL=$MODEL_CLASS_2
    fi
    echo "Using MAX model: $MAX_MODEL"
elif command -v rocm_agent_enumerator &> /dev/null; then
    echo "Detected AMD ROCm toolchain"
    gfx_arch=$(rocm_agent_enumerator | grep -v "^gfx000$" | head -n 1)
    echo "AMD GPU architecture: $gfx_arch"
    if [[ "$gfx_arch" =~ ^gfx94[2-9] ]]; then
        MAX_MODEL=$MODEL_CLASS_1
    else
        MAX_MODEL=$MODEL_CLASS_2
    fi
    echo "Using MAX model: $MAX_MODEL"
else
    MAX_MODEL=$MODEL_CLASS_3
    MAX_WEIGHTS=$MODEL_Q_WEIGHTS
fi