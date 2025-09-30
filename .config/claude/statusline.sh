#!/bin/bash

# Read Claude Code JSON input from stdin
input=$(cat)
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CLAUDE_CODE_VERSION=$(echo "$input" | jq -r '.version')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
SUBSCRIPTION=$(echo "$input" | jq -r '.subscription.tier // "Free"')

# ANSI color codes
ORANGE='\033[38;5;208m'
RESET='\033[0m'

# Claude ASCII art logo lines
LOGO_LINE1=" ▐▛███▜▌"
LOGO_LINE2="▝▜█████▛▘"
LOGO_LINE3="  ▘▘ ▝▝"

# Get git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" · $BRANCH"
    fi
fi

# Build the status line
printf "${ORANGE}%s${RESET}   Claude Code v%s\n" "$LOGO_LINE1" "$CLAUDE_CODE_VERSION"
printf "${ORANGE}%s${RESET}  %s · %s\n" "$LOGO_LINE2" "$MODEL_DISPLAY" "$SUBSCRIPTION"
printf "${ORANGE}%s${RESET}    %s%s" "$LOGO_LINE3" "$CURRENT_DIR" "$GIT_BRANCH"
