# AGENTS.md

## Cursor Cloud specific instructions

This is a documentation + shell-scripts repository (no application services, no build system, no package manager). The "application" is four Bash scripts in `scripts/` plus Markdown docs/templates.

### Prerequisites

- **Bash 4+** and **Git** are the only runtime requirements. Standard POSIX utilities (`date`, `df`, `awk`, `grep`, `sed`, `wc`) are used throughout.
- No package manager, no dependencies to install, no build step.

### Running the scripts

All scripts are already executable (`chmod +x`). Run from the repo root:

| Script | Command | Notes |
|--------|---------|-------|
| Morning startup | `bash scripts/daily-start.sh` | Read-only checks; safe to run anytime |
| End-of-day | `bash scripts/daily-end.sh` | **Creates commits and pushes** — will modify git state |
| Weekly review | `bash scripts/weekly-review.sh` | **Creates commits and pushes** — writes to `logs/weekly/` |
| New project | `bash scripts/new-project.sh "Name"` | Scaffolds under `projects/` (gitignored) |

### Gotchas

- `daily-end.sh` and `weekly-review.sh` both run `git add`, `git commit`, and `git push`. If you only want to test script execution without side effects, run on a throwaway branch or review generated files before they are committed.
- Generated daily/weekly logs under `logs/` are gitignored (see `.gitignore`). The `logs/` directory itself is kept via convention but contains no tracked files.
- `projects/` is fully gitignored — scaffolded projects won't appear in git status.

### Linting / Testing

There is no formal linter or test framework. To validate scripts:
- Run `bash -n scripts/*.sh` to syntax-check all scripts without executing them.
- Run each script individually to verify runtime behavior (see table above).
