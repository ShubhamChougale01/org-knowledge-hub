# Git Workflow Strategy — Org Knowledge Hub

This document defines how we manage code, collaborate on GitHub, and deploy the Org Knowledge Hub monorepo as a team.

---

## 1. Branching Strategy: Git Flow

We follow **Git Flow** — a proven branching model that separates development, releases, and hotfixes.

### Branch Types

| Branch | Purpose | Base | Naming | Lifecycle |
|---|---|---|---|---|
| **`main`** | Production-ready code | — | `main` | Permanent, protected |
| **`develop`** | Integration branch for features | `main` | `develop` | Permanent, protected |
| **`feature/*`** | New features, enhancements | `develop` | `feature/chat-improvements` | Temporary (PR → delete) |
| **`bugfix/*`** | Bug fixes | `develop` | `bugfix/auth-token-expiry` | Temporary (PR → delete) |
| **`release/*`** | Release prep, version bumps | `develop` | `release/1.2.0` | Temporary (PR → main + develop) |
| **`hotfix/*`** | Critical production fixes | `main` | `hotfix/security-patch` | Temporary (PR → main + develop) |

### Branch Rules

```
main
├── (production releases only)
├── protected: requires PR, 2 approvals, CI passing
│
develop
├── (integration of features)
├── protected: requires PR, 1 approval, CI passing
│
feature/*
├── branch from: develop
├── PR to: develop
├── delete after: PR merged
├── unprotected: work freely
│
bugfix/*
├── same as feature/*
│
release/*
├── branch from: develop
├── PR to: main (for release)
│ └── then PR main back to develop
└── unprotected: version bumps only
│
hotfix/*
├── branch from: main (urgent fixes)
├── PR to: main (quick merge)
├── then PR main back to develop
└── unprotected: critical fixes only
```

---

## 2. Commit Message Conventions

All commits follow **Conventional Commits** for clarity and automation (changelog generation, versioning).

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature (e.g., new API endpoint, new React component)
- **fix**: Bug fix (e.g., auth error, missing validation)
- **refactor**: Code restructuring without behavior change (e.g., extract function, rename variable)
- **perf**: Performance improvement (e.g., optimize query, cache results)
- **docs**: Documentation only (README, CLAUDE.md, guides)
- **style**: Code style, formatting, linting (no logic change)
- **test**: Add/modify tests (no production code change)
- **chore**: Maintenance (dependencies, CI config, tooling)
- **ci**: CI/CD pipeline changes
- **infra**: Infrastructure (Docker, database schema, deployment config)

### Scope

The area affected (choose one):

**Backend:** `auth`, `chat`, `graph`, `cache`, `llm`, `api`  
**Frontend:** `pages`, `components`, `store`, `api-client`, `ui`  
**Shared:** `config`, `types`, `docs`, `ci`, `docker`

### Subject

- Imperative mood: "add", "fix", "update" — NOT "added", "fixed", "updates"
- No period at end
- Max 50 characters
- Lowercase

### Examples

```
feat(chat): add multi-turn conversation memory
fix(auth): validate JWT expiry on every request
refactor(components): extract Employee card to separate file
perf(graph): add query result caching with 5-min TTL
docs(CLAUDE.md): add fastapi-testing skill reference
test(auth): add edge cases for login endpoint
chore(deps): bump neo4j from 5.18 to 5.20
ci: add TypeScript build step to GitHub Actions
infra(docker): update Neo4j image to 5.21
```

### Body & Footer

**Body** (optional but recommended for non-trivial commits):
- Explain the _why_, not the _what_ (code shows what)
- Wrap at 72 characters
- Separate from subject with blank line

**Footer** (optional):
- **Breaking change**: `BREAKING CHANGE: description`
- **Closes issue**: `Closes #123` (GitHub will auto-close)
- **References**: `Refs #456`
- **Attribution**: `Co-Authored-By: Name <email@example.com>`

### Full Example

```
feat(chat): add multi-turn conversation memory with history pruning

Implement SessionMemory service to track conversation context and
automatically prune messages older than 24 hours to prevent token bloat.
This enables pronouns and references across turns (e.g., "show me their team").

- Added memory.py service with Redis-backed history storage
- Inject history into LLM context for each chat request
- Prune old messages in background job (cron)
- Test coverage for edge cases (empty history, TTL expiry)

Closes #234
```

---

## 3. Pull Request (PR) Process

Every change goes through **peer review** before merging to `develop` or `main`.

### Creating a PR

1. **Push your branch** to GitHub:
   ```bash
   git push -u origin feature/your-feature-name
   ```

2. **Open PR on GitHub**:
   - Base: `develop` (or `main` for hotfixes)
   - Head: your branch
   - Title: `[Backend] Fix auth token expiry` or `[Frontend] Add employee search`
   - Description: Use the PR template (auto-filled)

3. **PR Template** (should auto-populate):
   ```markdown
   ## Summary
   - Brief description of what this PR does
   - Why it's needed
   - How it solves the problem

   ## Testing
   - [ ] Manual testing on localhost
   - [ ] All tests passing (npm test / pytest)
   - [ ] No new console errors or warnings
   - [ ] Tested edge cases

   ## Changes
   - List of files modified
   - Mention breaking changes if any

   ## Screenshots (if UI change)
   - Before/after screenshots

   ## Checklist
   - [ ] Code follows project conventions (see CONTRIBUTING.md)
   - [ ] Tests added/updated
   - [ ] Documentation updated if needed
   - [ ] No sensitive data (API keys, passwords) in commits
   - [ ] Branch is up-to-date with base branch
   ```

### PR Review Requirements

| Branch | Required | Dismiss | Auto-merge |
|---|---|---|---|
| **develop** | 1 approval | stale reviews dismissed | No |
| **main** | 2 approvals | stale reviews dismissed | No |
| **release/\*** | 1 approval | no dismiss | No |

All PRs must:
- ✅ Pass CI checks (tests, linting, build)
- ✅ Have at least 1 approval (2 for main)
- ✅ Have no conflicts with base branch
- ✅ Follow conventional commit format

### PR Review Guidelines

**Reviewers, check for:**
1. **Correctness**: Does the code do what it claims?
2. **Tests**: Are there tests? Do they cover edge cases?
3. **Performance**: Any obvious inefficiencies? (e.g., N+1 queries, unnecessary re-renders)
4. **Security**: No SQL injection, XSS, credential leaks, insecure crypto?
5. **Style**: Does it match project conventions?
6. **Documentation**: Are new features documented? CLI tested?

**Request changes** for:
- Breaking changes without discussion
- Missing tests
- Security issues
- Performance regressions

**Approve** if:
- Code is correct and tested
- No style violations
- Follows project conventions

### Handling PR Feedback

1. **Request changes** → Make fixes → Push to same branch (CI re-runs)
2. **Reviewers approve** → Branch is now mergeable
3. **Author merges** (or GitHub auto-merge if enabled)
4. **Delete remote branch** after merge

---

## 4. Committing & Pushing Code

### Local Workflow

```bash
# 1. Create feature branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/chat-improvements

# 2. Make changes, commit often with clear messages
git add backend/models/chat.py frontend/src/pages/ChatPage.tsx
git commit -m "feat(chat): add session memory to chat pipeline"

# 3. Before pushing, sync with develop (in case others pushed)
git fetch origin
git rebase origin/develop

# 4. Push to GitHub
git push -u origin feature/chat-improvements

# 5. Create PR on GitHub (link to issue if applicable)

# 6. After PR merged, clean up local branch
git checkout develop
git pull origin develop
git branch -d feature/chat-improvements
```

### Commit Checklist

Before `git commit`:
- [ ] Changes are focused (one concern per commit)
- [ ] Not committing large binaries or node_modules
- [ ] No hardcoded secrets (API keys, passwords)
- [ ] Tests pass locally: `npm test` / `pytest`
- [ ] Linting passes: `npm run lint` / similar
- [ ] Message follows Conventional Commits

---

## 5. Monorepo-Specific Concerns

### Backend & Frontend Both Changed?

If you modify both backend API and frontend UI (e.g., adding a new chat endpoint + UI):

1. **Single PR** covering both changes
2. **Separate commits** per package:
   ```
   feat(backend): add /chat/history endpoint
   feat(frontend): add conversation history UI
   ```
3. **Test both**:
   ```bash
   cd backend && pytest && cd ../frontend && npm test
   ```

### Cross-Package Dependencies

If backend types change and frontend imports them:

1. **Update both in the same PR**
2. **Commit order matters**:
   - Backend API/types first
   - Frontend consuming code second
   - Ensures both code states are coherent in git history

### Database Migrations

If you modify the Neo4j schema (e.g., add a new node type):

1. **Create a migration script** in `data/seeds/` with a unique ID
   - Naming: `12_new_feature_name.cypher`
   - Add to `data/load_data.py` execution order
2. **Commit the migration** with the backend code
3. **Update `data/seeds/README.md`** to document the change
4. **Test locally**:
   ```bash
   cd data && python load_data.py  # or cherry-run the new migration
   ```

### `.claude/` Configuration Changes

When updating `.claude/settings.json`, `.claude/skills/`, or `CLAUDE.md`:

- These affect the **entire team's experience** with Claude Code
- Require **at least 1 code review** (peer confirms the changes)
- Document why in the PR (e.g., "Refined deny rules to unblock Bash(npm *)")
- Consider impact on teammates working in other areas

---

## 6. Release & Deployment

### Preparing a Release

When ready to ship (e.g., v1.2.0):

1. **Create release branch**:
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b release/1.2.0
   ```

2. **Version bumps**:
   - Update version in `frontend/package.json` → `1.2.0`
   - Update version in `backend/pyproject.toml` or equivalent → `1.2.0`
   - Commit: `chore(release): bump version to 1.2.0`

3. **Update CHANGELOG.md**:
   - List all features, fixes, and breaking changes
   - Follow [Keep a Changelog](https://keepachangelog.com/) format
   - Commit: `docs(release): add CHANGELOG for 1.2.0`

4. **Create PR to main**:
   - Base: `main`
   - Title: `Release 1.2.0`
   - Requires 1 approval + CI passing

5. **After PR merged to main**:
   - Tag the release: `git tag v1.2.0 main`
   - Push tag: `git push origin v1.2.0`
   - Create GitHub Release (auto-generate from tag)

6. **Merge release branch back to develop**:
   - Create PR: `release/1.2.0` → `develop`
   - Merge to keep version bumps in sync

### Hotfixes (Critical Production Bugs)

1. **Create hotfix branch from main**:
   ```bash
   git checkout main
   git pull origin main
   git checkout -b hotfix/security-patch
   ```

2. **Make minimal fix** (one commit):
   ```bash
   git commit -m "fix(auth): patch JWT validation vulnerability"
   ```

3. **Bump patch version** (1.2.0 → 1.2.1):
   ```
   chore(release): bump version to 1.2.1
   ```

4. **Create PR to main** (expedited review):
   - Requires 1 approval (fast-track allowed for security)
   - CI must pass

5. **Tag & merge** to main (same as release)

6. **Merge back to develop** (same as release)

---

## 7. Team Roles & Permissions

### Repository Access Levels

| Role | Permissions | Responsibility |
|---|---|---|
| **Admin** | Create/delete branches, merge PRs, manage settings | Project lead (Shubham) — manages releases & prod access |
| **Maintainer** | Approve PRs, merge to develop, manage CI | Tech lead — code review, architecture decisions |
| **Developer** | Create branches, open PRs, review PRs | Team member — implement features, review peers |
| **Viewer** | Read-only | Stakeholders — see progress, not change code |

### Code Review Rotation

- **All PRs require peer review** — no self-approvals to main
- **Reviewers rotate** — don't always assign the same person
- **Frontend PRs reviewed by frontend developers** (ideally)
- **Backend PRs reviewed by backend developers** (ideally)
- **Cross-package changes reviewed by both**

---

## 8. Protection Rules (GitHub Settings)

### Main Branch

```
- Require pull request reviews before merging: YES (2 required)
- Dismiss stale pull request approvals when new commits are pushed: YES
- Require status checks to pass before merging: YES
  - required checks: tests, linting, build
- Require branches to be up to date before merging: YES
- Require code review from code owners: NO (but see CODEOWNERS below)
```

### Develop Branch

```
- Require pull request reviews before merging: YES (1 required)
- Dismiss stale pull request approvals: YES
- Require status checks to pass: YES
  - required checks: tests, linting, build
- Require branches to be up to date: YES
```

### CODEOWNERS File

Create `.github/CODEOWNERS` to auto-assign reviewers:

```
# Backend
/backend/ @backend-team-member1 @backend-team-member2

# Frontend
/frontend/ @frontend-team-member1 @frontend-team-member2

# Shared / Infrastructure
/.github/ @admin
/docker/ @admin
/data/ @admin
```

---

## 9. Continuous Integration (CI)

Every PR runs automated checks:

1. **Tests**:
   ```bash
   npm test          # frontend
   pytest            # backend
   ```

2. **Linting**:
   ```bash
   npm run lint      # eslint, prettier
   mypy, flake8      # python (if configured)
   ```

3. **Build**:
   ```bash
   npm run build     # frontend
   python -m py_compile  # backend (syntax check)
   ```

4. **Security** (optional):
   ```bash
   npm audit
   pip-audit
   ```

All must pass before merge. CI failures → fix → push → re-run automatically.

---

## 10. Quick Reference: Common Commands

```bash
# SETUP
git clone https://github.com/coditas/org-knowledge-hub.git
cd org-knowledge-hub

# FEATURE BRANCH
git checkout develop
git pull origin develop
git checkout -b feature/my-feature
# ... make changes ...
git commit -m "feat(backend): add new endpoint"
git push -u origin feature/my-feature
# ... open PR on GitHub ...

# SYNC WITH DEVELOP (before pushing)
git fetch origin
git rebase origin/develop
git push --force-with-lease

# CLEANUP
git checkout develop
git pull origin develop
git branch -d feature/my-feature
git push origin --delete feature/my-feature

# VIEW COMMIT HISTORY
git log --oneline --graph --all

# SEARCH COMMITS
git log --grep="chat" --oneline
git log -S "function_name" --oneline  # search code changes

# UNDO COMMITS (if not pushed)
git reset --soft HEAD~1  # undo last commit, keep changes staged
git reset --hard HEAD~1  # undo last commit, discard changes

# FORCE PUSH (careful!)
git push --force-with-lease  # safer than --force
```

---

## 11. GitHub Issues & Project Management

### Issue Labeling

Use labels to organize work:

- `type:bug` — defect, incorrect behavior
- `type:feature` — new functionality
- `type:enhancement` — improve existing feature
- `type:documentation` — docs, guides, comments
- `priority:critical` — blocks release or production
- `priority:high` — important, should do soon
- `priority:medium` — nice to have
- `priority:low` — backlog
- `backend`, `frontend`, `infra` — affected area
- `good first issue` — suitable for new contributors

### Linking PRs to Issues

In PR description or commit message:
```
Closes #123
Fixes #124
Refs #125  (related but not closing)
```

GitHub auto-closes the issue when PR merges.

---

## 12. Documentation

### Files to Keep Updated

| File | Purpose | When |
|---|---|---|
| `README.md` | Project overview, quickstart | Whenever setup changes |
| `CONTRIBUTING.md` | Contributor guide (created next) | When workflow changes |
| `CHANGELOG.md` | Release notes | Every release |
| `CLAUDE.md` (root) | Project overview for Claude Code | Whenever project structure changes |
| `backend/CLAUDE.md` | Backend specifics | When adding new components/services |
| `frontend/CLAUDE.md` | Frontend specifics | When adding new pages/features |
| `.github/CODEOWNERS` | Code review assignments | When team changes |
| `GIT_WORKFLOW.md` | This file | When workflow changes |

---

## Summary

| Item | Standard |
|---|---|
| **Branching** | Git Flow (main, develop, feature/*, release/*, hotfix/*) |
| **Commits** | Conventional Commits (feat, fix, refactor, etc.) |
| **PRs** | Base on develop, require 1+ approval, CI must pass |
| **Releases** | Release branches from develop, tag on main, semver |
| **Hotfixes** | Branch from main, merge back to both main & develop |
| **Protection** | main (2 approvals), develop (1 approval), require CI |
| **Reviews** | Peer review required, rotate reviewers |

---

**Questions?** Add them to an issue or ask the team lead.
