#!/bin/bash

# Non-interactive LLM commit message generator for Lazygit
# Self-contained script that gets staged diff and outputs commit message

# Check if there are staged changes
if ! git diff --cached --quiet; then
    # Get staged diff directly
    DIFF_CONTENT=$(git diff --cached --no-ext-diff)
else
    echo "error: no staged changes to commit"
    exit 1
fi

# Get branch name and extract scope from it
BRANCH=$(git branch --show-current)
# Extract scope from branch name (e.g., feature/auth -> auth, fix/api -> api)
SCOPE=$(echo "$BRANCH" | sed 's|.*/||' | tr '[:upper:]' '[:lower:]')
# If no slash in branch name, use branch as scope
if [ "$SCOPE" = "$BRANCH" ]; then
    SCOPE=$(echo "$BRANCH" | tr '[:upper:]' '[:lower:]')
fi

# Get diff statistics and file names for better context
DIFF_STAT=$(git diff --cached --name-only | sort -u)
FILE_COUNT=$(echo "$DIFF_STAT" | wc -l | tr -d ' ')
FILE_SUMMARY=$(git diff --cached --stat --stat-width=80)

# Check diff size for optimization
DIFF_SIZE=$(echo "$DIFF_CONTENT" | wc -c)

# For very large diffs, truncate to avoid token limits
if [ "$DIFF_SIZE" -gt 15000 ]; then
    # Take first 12000 chars and add truncation notice
    DIFF_CONTENT=$(echo "$DIFF_CONTENT" | head -c 12000)
    DIFF_CONTENT="${DIFF_CONTENT}

[... diff truncated - ${FILE_COUNT} files changed ...]"
fi

# Build the prompt with similar structure to Neovim config
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

Current branch: ${BRANCH}

SCOPE RULES:
- Use branch name as scope: ${SCOPE}
- If branch has prefixes like \"feature/\", \"fix/\", use the part after \"/\"
- Keep scope concise and lowercase

EXAMPLES:
feat(auth): add jwt token validation
fix(api): resolve cors headers issue  
docs(readme): update installation steps
test(user): add login validation tests
refactor(${SCOPE}): simplify error handling
build(${SCOPE}): update dependencies

Body (optional):
- Leave blank line after header
- Use bullet points for multiple changes
- Keep concise and technical
- No fluff or formal language

STRICT REQUIREMENTS:
- Header ≤ 72 chars
- All lowercase except proper nouns
- No period at end of subject
- Must have scope
- Return ONLY the commit message, no explanations

Files being changed (${FILE_COUNT} files):
${DIFF_STAT}

Summary:
${FILE_SUMMARY}

Diff content:
${DIFF_CONTENT}"

# Call LLM API (using environment variable for API endpoint)
API_URL="${COSMOS_API:-http://localhost:11434}/chat/completions"

# Build curl command with optional API key
CURL_HEADERS="-H \"Content-Type: application/json\""
if [ -n "$COSMOS_API_KEY" ]; then
  CURL_HEADERS="$CURL_HEADERS -H \"Authorization: Bearer $COSMOS_API_KEY\""
fi

# Make the API call with proper JSON escaping
RESPONSE=$(eval curl -s "$API_URL" \
  $CURL_HEADERS \
  -d "{
    \"model\": \"claude-sonnet-4\",
    \"messages\": [{
      \"role\": \"user\",
      \"content\": $(echo "$PROMPT" | jq -Rs .)
    }],
    \"max_tokens\": 500,
    \"temperature\": 0.3,
    \"stream\": false
  }")

# Extract the commit message from response
COMMIT_MSG=$(echo "$RESPONSE" | jq -r '.choices[0].message.content // empty' 2>/dev/null)

# Fallback error handling
if [ -z "$COMMIT_MSG" ] || [ "$COMMIT_MSG" = "null" ]; then
    # If API fails, try to generate a basic conventional commit
    TYPE="chore"
    if echo "$DIFF_CONTENT" | grep -q "test"; then
        TYPE="test"
    elif echo "$DIFF_CONTENT" | grep -q "fix\|bug\|error"; then
        TYPE="fix"
    elif echo "$DIFF_CONTENT" | grep -q "feat\|feature\|add"; then
        TYPE="feat"
    elif echo "$DIFF_CONTENT" | grep -q "docs\|readme\|comment"; then
        TYPE="docs"
    fi
    
    # Generate basic fallback message
    echo "${TYPE}(${SCOPE}): update ${FILE_COUNT} file(s)"
    exit 0
fi

# Output the generated commit message
echo "$COMMIT_MSG"