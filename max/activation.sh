#!/bin/bash

HF_TOKEN=$(op item get "Hugging Face" --fields credential --reveal 2>/dev/null)

if [ -z "$HF_TOKEN" ]; then
    echo "⚠️  Warning: Failed to retrieve HF_TOKEN from 1Password. Make sure you're authenticated with 'op signin'"
fi