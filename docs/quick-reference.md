# Quick Reference — Bryan's Workflow Cheat Sheet

> One-page cheat sheet.  Full details → [workflow.md](workflow.md) and
> [key-operations.md](key-operations.md).

---

## Daily Routine at a Glance

```
Morning                     During the Day              End of Day
──────────────────────────  ──────────────────────────  ──────────────────────────
1. Review carried tasks      Pick task from backlog      Commit / push WIP
2. Triage email / chat       Feature branch → work       Update daily log
3. Check calendar            Commit often                Clear inbox
4. Set top 3 priorities      Update ticket status        Run daily-end.sh
5. bash scripts/daily-start.sh  Open PR when done        Shut down cleanly
```

---

## Git — Most Used Commands

```bash
# Start work
git checkout -b feature/<id>-description

# During work
git add -p                            # stage interactively
git commit -m "type(scope): message"  # commit with convention
git diff --staged                     # review staged diff

# Stay current
git pull --rebase                     # rebase on remote changes

# End of task
git push -u origin <branch>           # push & set upstream
gh pr create                          # open pull request

# Utilities
git log --oneline --graph --decorate  # visual log
git stash push -m "desc"              # stash changes
git stash pop                         # restore stash
```

---

## File & System — Most Used Commands

```bash
ls -lah                   # list with sizes & hidden files
find . -name "*.log"      # find files by name
grep -r "pattern" .       # search file contents recursively
du -sh *                  # disk usage per item
df -h                     # free disk space
tar -czf out.tar.gz dir/  # compress directory
rsync -avz src/ dest/     # sync directories
tail -f logfile.log       # follow live log
ps aux | grep <name>      # find process
kill <PID>                # terminate process
```

---

## Commit Message Convention

```
<type>(<scope>): <short summary>
```

| Type | Use for |
|------|--------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Docs only |
| `chore` | Tooling / deps |
| `refactor` | Code restructure |
| `test` | Tests |

---

## Branch Naming

```
feature/<ticket-id>-short-description
fix/<ticket-id>-short-description
docs/<description>
chore/<description>
```

---

## Scripts Reference

| Script | Run with | What it does |
|--------|----------|-------------|
| `scripts/daily-start.sh` | `bash scripts/daily-start.sh` | Morning checks |
| `scripts/daily-end.sh` | `bash scripts/daily-end.sh` | EOD wrap-up |
| `scripts/weekly-review.sh` | `bash scripts/weekly-review.sh` | Weekly summary |
| `scripts/new-project.sh` | `bash scripts/new-project.sh "Name"` | Scaffold project |

---

## Security & Access

- Google SSO runbook:
  [`docs/google-sso-access-runbook.md`](google-sso-access-runbook.md)
- Primary accounts:
  - `bgillis99` mapped to a full Google identity
  - `admin@mobilecarsmoketest.com`

---

## Templates Reference

| Template | Purpose |
|----------|---------|
| `templates/daily-log.md` | Fill in daily |
| `templates/weekly-summary.md` | Fill in weekly |
| `templates/project-brief.md` | New project |
| `templates/meeting-notes.md` | Each meeting |

---

## Weekly Review Checklist

- [ ] All open projects reviewed & status updated
- [ ] Backlog groomed and next week prioritized
- [ ] `bash scripts/weekly-review.sh` run
- [ ] Weekly summary sent to stakeholders
- [ ] Monday top-3 priorities set
