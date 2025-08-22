#!/bin/bash

# Generate the commit message
MSG=$(/Users/jose/Documents/LATAM/.dotfiles/scripts/llm-commit-generator.sh)

if [ -z "$MSG" ]; then
    echo "Failed to generate commit message"
    exit 1
fi

# Create a temporary file with the message
TEMP_FILE=$(mktemp)
echo "$MSG" > "$TEMP_FILE"

# Open git commit with the message in editor
git commit -e -F "$TEMP_FILE"
RESULT=$?

# Clean up
rm -f "$TEMP_FILE"

exit $RESULT