---
allowed-tools: Bash(git *), AskUserQuestion
description: Smart commit - analyze all changes and ask what to include
---

## Context

- Current branch: !`git branch --show-current`
- Git status: !`git status`
- Staged changes (already added): !`git diff --cached --stat`
- Unstaged changes (modified but not added): !`git diff --stat`
- Untracked files: !`git ls-files --others --exclude-standard`

## Detailed diffs

### Staged changes (will be committed):
!`git diff --cached`

### Unstaged changes (NOT yet staged):
!`git diff`

## Recent commits (for message style reference):
!`git log --oneline -5`

## Your task

Analyze all changes and create a git commit intelligently:

### Step 1: Categorize changes

1. **Staged changes**: Changes that are already `git add`ed and ready to commit
2. **Unstaged changes**: Modified tracked files that haven't been staged
3. **Untracked files**: New files that git doesn't know about

### Step 2: Handle unstaged/untracked changes

If there are **unstaged changes** or **untracked files**, you MUST:

1. **Analyze each change/file**: Summarize what each modification does (e.g., "Added error handling to API", "New test file for auth module", "Config update for database")

2. **Ask the user** using the AskUserQuestion tool with options like:
   - "Commit all changes (staged + unstaged + untracked)"
   - "Commit only staged changes"
   - "Let me select specific files" (then follow up with file list)

3. Include a brief summary of each category in the question description, for example:
   ```
   Staged (ready to commit):
   - src/api.ts: Refactored authentication logic

   Unstaged (not yet staged):
   - src/utils.ts: Added helper function for date formatting
   - config.json: Updated timeout values

   Untracked (new files):
   - src/newFeature.ts: New feature implementation
   ```

### Step 3: Stage and commit

Based on user's choice:
- If "all changes": `git add -A` then commit
- If "staged only": commit directly (no additional staging)
- If "select specific": ask which files, then `git add <files>` and commit

### Step 4: Create commit message

- Write a clear, concise commit message based on the changes
- Follow the repository's commit style from recent commits
- Use conventional commit format if the repo uses it

### Important rules

- NEVER skip the analysis step when unstaged/untracked changes exist
- ALWAYS explain what each change does before asking
- If there are NO unstaged/untracked changes (only staged), proceed directly to commit
- Use `git add -p` is NOT allowed (interactive mode doesn't work)
- Do NOT add Co-Authored-By lines to commit messages
