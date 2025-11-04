#!/bin/bash

if [ -z "$HF_TOKEN" ]; then
    HF_TOKEN=$(op item get "Hugging Face" --fields credential --reveal 2>/dev/null)
fi

if [ -z "$HF_TOKEN" ]; then
    echo "⚠️  Warning: Failed to retrieve HF_TOKEN from 1Password. Make sure you're authenticated with 'op signin'"
fi

CLASS_1_MODEL="OpenGVLab/InternVL3-14B-Instruct"
CLASS_2_MODEL="Qwen/Qwen2.5-VL-7B-Instruct"
CLASS_3_MODEL="HuggingFaceTB/SmolLM2-1.7B-Instruct"
CLASS_3_WEIGHTS="HuggingFaceTB/SmolLM2-1.7B-Instruct-GGUF/smollm2-1.7b-instruct-q4_k_m.gguf"

if command -v nvidia-smi &> /dev/null; then
    echo "Detected NVIDIA toolchain"
    compute_cap=$(nvidia-smi --query-gpu compute_cap --format=csv,noheader)
    echo "CUDA compute capacity: $compute_cap"
    unset MAX_WEIGHTS
    if (( $(printf "%.0f" "$compute_cap") >= 9 )); then
        export MAX_MODEL="--model $CLASS_1_MODEL"
    else
        export MAX_MODEL="--model $CLASS_2_MODEL"
    fi
elif command -v rocm_agent_enumerator &> /dev/null; then
    echo "Detected AMD ROCm toolchain"
    gfx_arch=$(rocm_agent_enumerator | grep -v "^gfx000$" | head -n 1)
    echo "AMD GPU architecture: $gfx_arch"
    unset MAX_WEIGHTS
    if [[ "$gfx_arch" =~ ^gfx94[2-9] ]]; then
        export MAX_MODEL="--model $CLASS_1_MODEL"
    else
        export MAX_MODEL="--model $CLASS_2_MODEL"
    fi
else
    echo "No NVIDIA or AMD toolchain detected"
    echo "Default set to CPU-only model"
    export MAX_MODEL="--model $CLASS_3_MODEL"
    export MAX_WEIGHTS="--weight-path $CLASS_3_WEIGHTS"
fi

echo "max serve default args: $MAX_MODEL $MAX_WEIGHTS"