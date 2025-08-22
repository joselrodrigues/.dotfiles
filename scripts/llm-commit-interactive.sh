#!/bin/bash

# Generate the commit message
echo "Generating commit message with LLM..."
MSG=$(/Users/jose/Documents/LATAM/.dotfiles/scripts/llm-commit-generator.sh)

if [ -z "$MSG" ]; then
    echo "Failed to generate commit message"
    exit 1
fi

# Create a temporary file with the message
TEMP_FILE=$(mktemp)
echo "$MSG" > "$TEMP_FILE"

echo ""
echo "Generated message:"
echo "=================="
cat "$TEMP_FILE"
echo "=================="
echo ""

# Show options
while true; do
    read -p "Actions: (u)se as-is, (e)dit, (r)egenerate, (c)ancel: " choice
    case $choice in
        u|U)
            git commit -F "$TEMP_FILE"
            RESULT=$?
            break
            ;;
        e|E)
            ${EDITOR:-vim} "$TEMP_FILE"
            git commit -F "$TEMP_FILE"
            RESULT=$?
            break
            ;;
        r|R)
            echo "Regenerating..."
            MSG=$(/Users/jose/Documents/LATAM/.dotfiles/scripts/llm-commit-generator.sh)
            if [ -n "$MSG" ]; then
                echo "$MSG" > "$TEMP_FILE"
                echo ""
                echo "New generated message:"
                echo "======================"
                cat "$TEMP_FILE"
                echo "======================"
                echo ""
            else
                echo "Failed to regenerate message"
            fi
            ;;
        c|C)
            echo "Commit cancelled"
            rm -f "$TEMP_FILE"
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose u, e, r, or c"
            ;;
    esac
done

# Clean up
rm -f "$TEMP_FILE"
exit $RESULT