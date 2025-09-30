#!/bin/bash

# Read Claude Code JSON input from stdin
input=$(cat)
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CLAUDE_CODE_VERSION=$(echo "$input" | jq -r '.version')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
SESSION_ID=$(echo "$input" | jq -r '.session_id')

# ANSI color codes
BOLD='\033[1m'
ORANGE='\033[38;2;217;119;87m'
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
        GIT_BRANCH=" · git:$BRANCH"
    fi
fi

# Build the status line
printf "${BOLD}${ORANGE}%s${RESET}   Claude Code %s\n" "$LOGO_LINE1" "$CLAUDE_CODE_VERSION"
printf "${BOLD}${ORANGE}%s${RESET}  %s · %s\n" "$LOGO_LINE2" "$MODEL_DISPLAY" "$SESSION_ID"
printf "${BOLD}${ORANGE}%s${RESET}    %s%s" "$LOGO_LINE3" "$CURRENT_DIR" "$GIT_BRANCH"
