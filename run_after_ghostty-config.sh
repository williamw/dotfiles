#!/bin/bash
# Symlink ghostty config to macOS Library path so edits in either location stay in sync
if [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
    ln -sf ~/.config/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
fi
