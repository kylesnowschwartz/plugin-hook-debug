# Plugin Hook Output Capture Bug Reproduction

Minimal reproduction case for https://github.com/anthropics/claude-code/issues/10875

## Issue

Plugin hooks execute successfully but Claude Code never captures/parses their JSON output, while identical inline hooks work correctly.

## Setup

This repo contains two nearly-identical bash Stop hooks:

1. **Inline hook** (configured in `.claude/settings.json`): `hooks/entrypoints/stop.sh`
2. **Plugin hook** (auto-discovered from plugin): `plugins/test-plugin/hooks/entrypoints/stop.sh`

Both hooks:
- Read input from STDIN
- Output valid JSON with `decision: "block"` and a reason message and suppress output true
- Exit with code 2

The only difference is the reason text to identify which hook executed.

## Steps:
###'Inline' hook (working)
1. Ensure 'inline' stop hook is configured in your local settings.json file and plugin is disabled
2. Type anything - see the inline hook response:

##'Plugin' hook (not working)
1. Remove the 'inline' hook config from your settings.json, add the test-plugin marketplace and enable the plugin
2. Type anything - see the different response:

## Debug Log Comparison

**Working (inline hook):**
```
[DEBUG] Matched 1 unique hooks for query "no match query"
[DEBUG] Hooks: Checking initial response for async: {"continue":true,...}
[DEBUG] Successfully parsed and validated hook JSON output
```

**Broken (plugin hook):**
```
[DEBUG] Matched 1 unique hooks for query "no match query"
[DEBUG] Hooks: getAsyncHookResponseAttachments called
[DEBUG] Hooks: checkForNewResponses called
```

The plugin hook output is never captured or parsed.

## Environment

- Platform: darwin
- Version: 2.0.31
