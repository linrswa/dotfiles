---
name: ask-codex
description: >
  Delegate tasks to OpenAI Codex CLI for review and get responses back.
  Use when user explicitly asks to "ask codex", "let codex review", or "pass to codex",
  or wants a second opinion from another AI on code or text,
  or wants code review via codex review command.
---

# Ask Codex

Invoke OpenAI Codex CLI to review content and return results for discussion.

## Modes

### 1. Code Review Mode (`codex review`)

For reviewing git changes:

```bash
# Review uncommitted changes
codex review --uncommitted

# Review against a branch
codex review --base main

# Review a specific commit
codex review --commit <sha>

# With custom instructions
codex review --uncommitted "Focus on security issues"
```

### 2. General Query Mode (`codex exec`)

For arbitrary prompts (read-only by default):

```bash
# Ask codex a question (read-only sandbox)
codex exec -s read-only "Review this code and explain potential issues: <content>"

# Pass content via stdin
echo "content to review" | codex exec -s read-only -
```

## Workflow

1. Determine appropriate mode based on user request:
   - Git changes → use `codex review`
   - Arbitrary content → use `codex exec -s read-only`

2. Execute codex command and capture output

3. Present codex's response to user

4. If issues found, discuss with user and offer to help resolve

## Examples

**User:** "Ask codex to review my uncommitted changes"
```bash
codex review --uncommitted
```

**User:** "Let codex review this function for bugs"
```bash
codex exec -s read-only "Review this function for potential bugs and suggest improvements:

<paste function code here>"
```

**User:** "Get codex's opinion on my PR against main"
```bash
codex review --base main
```

## Important

- Default to read-only sandbox (`-s read-only`) unless user explicitly allows edits
- Always show codex's full response to user
- Discuss any issues or suggestions with user before taking action
