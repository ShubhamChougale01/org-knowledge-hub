# /git-push — Safe Review → Stage → Commit → Push Workflow

You are running a **safe git push workflow** for this project. Your job is to review the diff, verify changes look good, then stage, commit, and push them automatically.

---

## STEP 1 — Check for changes

Run this command to check git status:

```bash
git status --short
```

**If output is empty:**
- Stop here. Tell the user: "✅ No changes detected. Nothing to commit."
- Exit without proceeding further.

**If output shows files (e.g., `M file.md`, `?? new_file.py`):**
- Proceed to STEP 2.

---

## STEP 2 — Show the full diff

Run these commands to see ALL changes:

```bash
git diff
```

Then:

```bash
git diff --cached
```

Then list untracked files:

```bash
git status --short
```

**Output:**
- Display the diff clearly to the user (use code blocks with syntax highlighting if possible)
- Summarize: "X files changed, Y insertions(+), Z deletions(-)"

---

## STEP 3 — Review the changes for issues

Read through the entire diff carefully. Look for:

- ⚠️ **Debug code:** `console.log()`, `print()`, `debugger`, `TODO`, `FIXME`, `HACK`
- ⚠️ **Accidental large deletions:** Entire sections removed unexpectedly
- ⚠️ **Sensitive data:** API keys, passwords, tokens, secrets in plaintext
- ⚠️ **Syntax errors:** Obvious Python/JS/TypeScript errors, broken imports
- ⚠️ **Uncommitted node_modules, .env, or build artifacts** in untracked files

**Report your findings:**

If you find issues:
```
❌ REVIEW FOUND ISSUES:
- Line 42: console.log() left in production code
- Line 88: Hardcoded API key in plaintext
```
Ask the user: "Fix these issues before committing? (yes/no)"
If yes → Stop and tell them to fix it.
If no → Ask for confirmation: "Proceed anyway? (This is risky)" and wait for response.

If changes look clean:
```
✅ Review complete — changes look clean!
- No debug code detected
- No secrets found
- All changes align with the commit purpose
```

Proceed to STEP 4.

---

## STEP 4 — Get the commit message

Check the user's input for the `/git-push` command:

**Case 1: User provided a message**
- If they typed `/git-push "docs: add guide"`, the message is `"docs: add guide"`
- Use this as your commit message
- Skip to STEP 5

**Case 2: No message provided**
- Ask the user: "What should the commit message be? (Be concise and descriptive)"
- Wait for their response
- Use their response as the commit message

**Commit message format (required):**
- Use conventional commits style: `<type>: <description>`
- Type: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `style`
- Example: `docs: add knowledge graph guide`, `feat: add /git-push command`

---

## STEP 5 — Confirm before committing

Show the user a summary:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 COMMIT SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files to be staged:
  (list the modified and new files from STEP 1)

Commit message:
  "your commit message here"

Target branch:
  <current-branch> → origin/<current-branch>

Ready to proceed?
```

Get the current branch with:
```bash
git rev-parse --abbrev-ref HEAD
```

Ask the user: **"Proceed with staging, committing, and pushing? (yes/no)"**

If they say no:
- Stop and tell them: "❌ Aborted by user. No changes committed."
- Exit without making changes.

If they say yes:
- Proceed to STEP 6.

---

## STEP 6 — Stage all changes

Run:

```bash
git add -A
```

Then verify:

```bash
git status
```

Report:
```
✅ All changes staged
(show the output of git status to confirm)
```

---

## STEP 7 — Commit with Co-Author trailer

Create the commit with this exact format:

```bash
git commit -m "docs: add example message

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>"
```

**Important:**
- Replace the first line (`docs: add example message`) with the actual commit message from STEP 4
- The second line (blank) is required
- The `Co-Authored-By` trailer is always included, unchanged
- Use multiline format via Bash heredoc or -m flag with line breaks

After commit, show:

```bash
git log -1 --oneline
```

Report:
```
✅ Commit created
(show the one-liner output, e.g., e0f59c7 docs: add knowledge graph guide)
```

---

## STEP 8 — Push to remote

Get the current branch (if not already done):

```bash
git rev-parse --abbrev-ref HEAD
```

Push with:

```bash
git push origin <BRANCH_NAME>
```

Replace `<BRANCH_NAME>` with the actual branch name from the command above.

**If push succeeds:**

```bash
git log -1 --oneline
```

Report:
```
✅ Changes pushed successfully!

Final commit:
  (show the one-liner)

Branch: <branch-name> → origin/<branch-name>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✨ Safe push workflow complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**If push fails:**

Stop and report the error to the user:
```
❌ Push failed with error:
(show the git error message)

Possible causes:
- Branch protection rules (need PR approval)
- Merge conflicts (need to pull and resolve)
- No upstream tracking (need to set upstream)
```

---

## Summary of the Full Workflow

```
1. Check for changes (abort if none)
     ↓
2. Show diff to user
     ↓
3. Review for issues (debug code, secrets, etc.)
     ↓
4. Get commit message (from args or ask user)
     ↓
5. Show summary & ask confirmation
     ↓
6. Stage changes (git add -A)
     ↓
7. Commit (with Co-Author trailer)
     ↓
8. Push to remote
     ↓
✨ Done!
```

---

## User Invocation

Users will invoke this command as:

- `/git-push` → Interactive (asks for commit message)
- `/git-push "feat: add feature"` → Auto-uses the message, skips the ask
- `/git-push "docs: fix typo"` → Works the same way

Your job is to follow all 8 steps in order and make the process smooth and safe.
