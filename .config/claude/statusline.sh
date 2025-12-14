#!/bin/bash

# Read Claude Code JSON input from stdin
input=$(cat)
CLAUDE_CODE_VERSION=$(echo "$input" | jq -r '.version')
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Get git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" · git:$BRANCH"
    fi
fi

# Build the status line (single line)
printf "Claude Code v%s · %s · %s%s" "$CLAUDE_CODE_VERSION" "$MODEL_DISPLAY" "$CURRENT_DIR" "$GIT_BRANCH"
