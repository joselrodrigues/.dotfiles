#!/bin/bash

# Generate commit message
MSG=$(/Users/jose/Documents/LATAM/.dotfiles/scripts/llm-commit-msg.sh)

if [ $? -ne 0 ]; then
    echo "Failed to generate commit message"
    exit 1
fi

# Create temp file with the message
TEMP_FILE=$(mktemp)
echo "$MSG" > "$TEMP_FILE"

# Open git commit with the template
git commit -t "$TEMP_FILE" -e

# Clean up
rm -f "$TEMP_FILE"