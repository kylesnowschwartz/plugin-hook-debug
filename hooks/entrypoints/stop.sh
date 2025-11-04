#!/bin/bash
# Simple Stop hook that blocks (forces continuation) - reproduction for plugin hook bug

# Read input from STDIN (Claude Code passes hook data as JSON)
read -r input

# Check if stop hook is already active (prevents infinite loop)
stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active // false')

if [ "$stop_hook_active" = "true" ]; then
  # Already triggered once, allow normal stop
  echo '{"continue":true,"stopReason":"","suppressOutput":true}' >&1
  exit 0
fi

# Output valid JSON response to STDERR (required when exit code is 2)
echo '{"continue":true,"stopReason":"","suppressOutput":true,"decision":"block","reason":"I notice I just used a reflexive agreement phrase. Let me provide a more substantive response:\n\nInstead of simply agreeing, let me analyze your point with specific technical reasoning, consider potential edge cases or alternative approaches, and offer constructive insights that build collaboratively on your observation."}' >&2

# Exit with code 2 to force continuation
exit 2
