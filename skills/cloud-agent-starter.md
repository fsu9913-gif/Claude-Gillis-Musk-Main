# Cloud Agent Starter Skill (Minimal)

Use this skill as the first-stop runbook when a Cloud agent starts work in this repository.

## 1) Immediate setup checklist (first 60 seconds)

1. Confirm repo root and branch:
   - `pwd` (should be repo root)
   - `git status -sb`
2. Confirm required tools:
   - `bash --version`
   - `git --version`
3. Confirm git remote access before running scripts that push:
   - `git remote -v`
   - `git fetch origin main`
4. Confirm script syntax before execution:
   - `bash -n scripts/*.sh`

Notes for this codebase:
- There is no web app or server to start.
- There are no feature flags to set or mock.
- Runtime requirements are Bash + Git + standard POSIX tools only.

---

## 2) Codebase areas and practical workflows

### Area A: `scripts/` (core executable behavior)

Scripts in scope:
- `scripts/daily-start.sh` (read-only checks)
- `scripts/daily-end.sh` (commits + pushes)
- `scripts/weekly-review.sh` (writes weekly log + commits + pushes)
- `scripts/new-project.sh "Name"` (scaffolds under gitignored `projects/`)

#### Fast smoke test (safe)
Run this on any branch:
1. `bash -n scripts/*.sh`
2. `bash scripts/daily-start.sh`

Expected:
- Syntax check exits 0.
- Daily startup script prints sections for disk, git status, and carry-overs.

#### Mutating script test workflow (use when task touches script logic)
Because two scripts commit/push, run mutating tests carefully:
1. Inspect working tree first: `git status --short`
2. If dirty, checkpoint intentionally before testing.
3. Run one script at a time and inspect effects:
   - `bash scripts/daily-end.sh`
   - `bash scripts/weekly-review.sh`
4. Validate resulting git state:
   - `git status -sb`
   - `git log --oneline -n 5`
5. Confirm generated files:
   - `logs/daily/<YYYY-MM-DD>.md` (ignored)
   - `logs/weekly/week-of-<YYYY-MM-DD>.md` (ignored)

When testing `new-project.sh`:
1. `bash scripts/new-project.sh "Skill Smoke Test"`
2. Confirm scaffolded paths exist under `projects/`.
3. Confirm no top-level tracked changes leaked: `git status -sb`

---

### Area B: `docs/` and root docs (`README.md`, `Claude.md`, `AGENTS.md`)

Use this workflow for documentation-only changes:
1. Validate links and command snippets manually against scripts/docs.
2. Run script syntax guard anyway (prevents stale command docs):
   - `bash -n scripts/*.sh`
3. Run one executable example from docs (prefer non-mutating):
   - `bash scripts/daily-start.sh`

Expected:
- Commands documented for startup remain accurate.
- No unexpected git mutations from verification commands.

---

### Area C: `templates/`

Templates are consumed by scripts at runtime.

Test workflow after changing templates:
1. If editing `templates/daily-log.md`, run:
   - `bash scripts/daily-end.sh` (mutating; commits/pushes)
2. If editing `templates/weekly-summary.md`, run:
   - `bash scripts/weekly-review.sh` (mutating; commits/pushes)
3. If editing `templates/project-brief.md`, run:
   - `bash scripts/new-project.sh "Template Validation"`
   - Inspect `projects/template-validation/docs/project-brief.md`

Validation focus:
- Placeholder substitution still works (project name/date).
- Output markdown remains readable and complete.

---

## 3) Known environment/workflow gotchas

- `daily-end.sh` and `weekly-review.sh` are not dry-run scripts; they stage, commit, and push.
- `logs/daily/*.md` and `logs/weekly/*.md` are intentionally gitignored.
- `projects/` is fully gitignored, so scaffolded projects do not appear in normal status output.
- If upstream is unavailable, push calls may fail; scripts continue with warning output.

---

## 4) Minimal acceptance checklist for agent PRs

For most changes in this repo, include these checks in your agent summary:
1. `bash -n scripts/*.sh`
2. At least one runtime script execution proving command validity:
   - usually `bash scripts/daily-start.sh`
3. `git status -sb` before/after test to explain side effects (or lack of side effects).

If script behavior changed, include the exact script run used for validation and the resulting git/log side effects.

---

## 5) How to update this skill when new runbook knowledge is found

When you discover a new reliable troubleshooting step or testing trick:
1. Add it to the smallest relevant section above (`scripts/`, `docs/`, or `templates/`).
2. Include:
   - the trigger/symptom,
   - exact command(s),
   - expected output/state.
3. Keep it concrete and copy-pastable (avoid generic advice).
4. In the same PR, prove the new instruction works by running it and citing output in the PR description.
5. Prefer incremental edits over rewrites so future agents can track what changed and why.
