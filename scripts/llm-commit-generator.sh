#!/bin/bash

# Get branch name and stats
BRANCH=$(git branch --show-current)
DIFF_STAT=$(git diff --staged --stat)
FILE_NAMES=$(git diff --staged --name-status)

# Check diff size
DIFF_SIZE=$(git diff --staged --no-ext-diff | wc -c)

if [ "$DIFF_SIZE" -lt 10000 ]; then
    DIFF_CONTENT=$(git diff --no-ext-diff --staged)
else
    # For large diffs, show summary
    DIFF_CONTENT="LARGE DIFF - Summary:

$DIFF_STAT

Files changed:
$FILE_NAMES"
fi

# Prepare the prompt
PROMPT="You are an expert at following Conventional Commits and commitlint rules. Generate a commit message following these STRICT rules:

COMMITLINT RULES (MANDATORY):
- type-enum: ONLY use: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- scope-empty: MUST have a scope (never empty)
- type-case: type MUST be lowercase
- subject-case: subject MUST be lowercase
- subject-empty: subject MUST NOT be empty
- subject-full-stop: subject MUST NOT end with period
- header-max-length: first line MUST be ≤ 72 characters

FORMAT: type(scope): subject

Current branch: $BRANCH

SCOPE RULES:
- Use branch name as scope: $BRANCH
- If branch has prefixes like \"feature/\", \"fix/\", use the part after \"/\"
- Keep scope concise and lowercase

Return ONLY the commit message (can include body with blank line separation), no explanations.

Changes:
$DIFF_CONTENT"

# Call your LLM API
API_URL="${COSMOS_API}/chat/completions"
RESPONSE=$(curl -s "$API_URL" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"claude-sonnet-4\",
    \"messages\": [{\"role\": \"user\", \"content\": $(echo "$PROMPT" | jq -Rs .)}],
    \"max_tokens\": 500,
    \"temperature\": 0.5
  }")

# Extract the commit message from response
COMMIT_MSG=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null)

if [ -z "$COMMIT_MSG" ] || [ "$COMMIT_MSG" = "null" ]; then
    # Return empty if generation fails
    exit 0
fi

# Output just the message - lazygit will handle newlines properly
echo "$COMMIT_MSG"