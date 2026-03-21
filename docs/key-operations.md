# Key Operation Uses

A comprehensive reference of the commands, tools, and patterns Bryan uses
across all areas of work.  Organized by category for quick lookup.

---

## Table of Contents

1. [File & Directory Management](#1-file--directory-management)
2. [Version Control (Git)](#2-version-control-git)
3. [Scripting & Automation](#3-scripting--automation)
4. [Text Editing & Search](#4-text-editing--search)
5. [Process & System Monitoring](#5-process--system-monitoring)
6. [Networking & Remote Access](#6-networking--remote-access)
7. [Communication & Scheduling Tools](#7-communication--scheduling-tools)
8. [Reporting & Documentation](#8-reporting--documentation)

---

## 1. File & Directory Management

| Operation | Command / Action | Notes |
|-----------|-----------------|-------|
| List directory contents | `ls -lah` | Human-readable sizes, hidden files |
| Navigate to directory | `cd <path>` | Use tab-completion |
| Create directory tree | `mkdir -p path/to/dir` | Creates parents as needed |
| Copy file | `cp source dest` | Add `-r` for directories |
| Move / rename | `mv old new` | Also used to rename |
| Delete (safe) | `rm -i file` | Prompts before delete |
| Delete directory | `rm -rf dir/` | **Caution:** irreversible |
| Find files by name | `find . -name "*.log"` | Recursive by default |
| Find files by content | `grep -r "pattern" .` | Add `--include="*.py"` to filter |
| Disk usage | `du -sh *` | Summary per item in cwd |
| Free disk space | `df -h` | All mount points |
| Archive & compress | `tar -czf archive.tar.gz dir/` | Create gzipped tarball |
| Extract archive | `tar -xzf archive.tar.gz` | Extract in place |
| Sync directories | `rsync -avz src/ dest/` | Add `--delete` to mirror |

---

## 2. Version Control (Git)

### Daily Git Operations

| Operation | Command | Notes |
|-----------|---------|-------|
| Clone repository | `git clone <url>` | |
| Check status | `git status` | |
| Stage all changes | `git add .` | |
| Stage interactively | `git add -p` | Review hunks before staging |
| Commit | `git commit -m "message"` | Follow commit convention |
| Amend last commit | `git commit --amend` | Before pushing only |
| Push branch | `git push -u origin <branch>` | `-u` sets upstream |
| Pull with rebase | `git pull --rebase` | Keeps history linear |
| Create branch | `git checkout -b <name>` | |
| Switch branch | `git checkout <name>` | |
| List branches | `git branch -a` | Local and remote |
| Delete local branch | `git branch -d <name>` | Use `-D` to force |
| Delete remote branch | `git push origin --delete <name>` | |
| View log (compact) | `git log --oneline --graph --decorate` | |
| View diff staged | `git diff --staged` | |
| Stash changes | `git stash push -m "description"` | |
| Pop stash | `git stash pop` | |
| Tag release | `git tag -a v1.0.0 -m "Release 1.0.0"` | Annotated tag |

### Branch Naming Convention

```
feature/<ticket-id>-short-description
fix/<ticket-id>-short-description
chore/<ticket-id>-short-description
docs/<description>
```

### Merge vs Rebase Strategy

| Scenario | Strategy |
|----------|----------|
| Integrating feature branch → main | **Squash merge** (clean history) |
| Staying current with main (on feature branch) | **Rebase** (`git rebase main`) |
| Hotfix → main | **Merge commit** (preserves emergency context) |

---

## 3. Scripting & Automation

| Operation | Command / Pattern | Notes |
|-----------|------------------|-------|
| Run a bash script | `bash script.sh` | Or `./script.sh` after `chmod +x` |
| Make script executable | `chmod +x script.sh` | |
| Schedule recurring task | `crontab -e` | Edit cron table |
| Common cron syntax | `0 9 * * 1-5 cmd` | 9 AM Mon–Fri |
| Run in background | `cmd &` | Detaches to background |
| View background jobs | `jobs` | |
| Bring to foreground | `fg %1` | |
| Pipe output | `cmd1 \| cmd2` | Chain commands |
| Redirect stdout to file | `cmd > file.txt` | Overwrites |
| Append stdout to file | `cmd >> file.txt` | Appends |
| Capture stderr too | `cmd > file.txt 2>&1` | |
| Suppress output | `cmd > /dev/null 2>&1` | |
| Loop over files | `for f in *.md; do echo "$f"; done` | |
| Check exit code | `echo $?` | 0 = success |

---

## 4. Text Editing & Search

| Operation | Command / Shortcut | Notes |
|-----------|-------------------|-------|
| Open file in VS Code | `code file.txt` | |
| Open folder in VS Code | `code .` | |
| Search in VS Code | `Ctrl+Shift+F` | Global search |
| Search in file (VS Code) | `Ctrl+F` | |
| Replace in file (VS Code) | `Ctrl+H` | |
| Grep for pattern | `grep -n "pattern" file` | Line numbers |
| Grep recursively | `grep -r "pattern" dir/` | |
| Case-insensitive grep | `grep -i "pattern" file` | |
| Count matches | `grep -c "pattern" file` | |
| Show only filenames | `grep -l "pattern" *` | |
| Sort lines | `sort file.txt` | |
| Remove duplicate lines | `sort -u file.txt` | |
| Count lines/words/chars | `wc -l file.txt` | |
| View file paginated | `less file.txt` | `q` to quit |
| View last N lines | `tail -n 20 file.txt` | |
| Follow live log | `tail -f logfile.log` | |

---

## 5. Process & System Monitoring

| Operation | Command | Notes |
|-----------|---------|-------|
| List running processes | `ps aux` | All users |
| Interactive process view | `top` or `htop` | `q` to quit |
| Find process by name | `pgrep -la python` | |
| Kill process by PID | `kill <PID>` | Graceful (SIGTERM) |
| Force kill | `kill -9 <PID>` | SIGKILL |
| Check open ports | `ss -tlnp` | TCP listening |
| Check port in use | `lsof -i :<port>` | |
| System uptime | `uptime` | |
| Memory usage | `free -h` | |
| CPU info | `lscpu` | |
| View system logs | `journalctl -xe` | systemd logs |
| Check service status | `systemctl status <service>` | |
| Start / stop service | `systemctl start/stop <service>` | |

---

## 6. Networking & Remote Access

| Operation | Command | Notes |
|-----------|---------|-------|
| Ping host | `ping -c 4 host` | 4 packets |
| Trace route | `traceroute host` | |
| DNS lookup | `dig host` | |
| HTTP request (curl) | `curl -I https://example.com` | Headers only |
| Download file | `curl -O https://example.com/file` | |
| SSH to server | `ssh user@host` | |
| SSH with key | `ssh -i ~/.ssh/key.pem user@host` | |
| Copy file to server | `scp file user@host:/path/` | |
| Copy from server | `scp user@host:/path/file .` | |
| Mount remote fs | `sshfs user@host:/path /mnt/point` | |
| Transfer with rsync | `rsync -avz -e ssh src/ user@host:dest/` | |
| Check open connections | `netstat -an` | |

---

## 7. Communication & Scheduling Tools

### Email (Gmail / Outlook shortcuts)

| Action | Shortcut |
|--------|---------|
| Compose new | `c` (Gmail) / `Ctrl+N` (Outlook) |
| Reply | `r` (Gmail) / `Ctrl+R` (Outlook) |
| Reply all | `a` (Gmail) / `Ctrl+Shift+R` (Outlook) |
| Forward | `f` (Gmail) / `Ctrl+F` (Outlook) |
| Archive | `e` (Gmail) |
| Search | `/` (Gmail) |
| Mark as read | `Shift+I` (Gmail) |
| Snooze | `b` (Gmail) |

### Slack / Teams Key Shortcuts

| Action | Shortcut |
|--------|---------|
| Jump to conversation | `Ctrl+K` |
| Mark all as read | `Shift+Esc` |
| Format code block | ` ``` code ``` ` |
| Mention someone | `@username` |
| React with emoji | `:emoji_name:` |
| Search messages | `Ctrl+F` |
| Set status | Profile → Set Status |

### Calendar (Google Calendar / Outlook)

| Action | Key Use |
|--------|---------|
| Create event | Click time slot and type |
| Invite attendees | Add in event editor |
| Block focus time | Create "Focus Time" or "Busy" event |
| View week | `W` (Google Calendar) |
| View day | `D` |

---

## 8. Reporting & Documentation

| Operation | Command / Tool | Notes |
|-----------|---------------|-------|
| Generate weekly summary | `bash scripts/weekly-review.sh` | Outputs Markdown |
| Render Markdown preview | VS Code `Ctrl+Shift+V` | |
| Convert Markdown → PDF | `pandoc file.md -o file.pdf` | Requires pandoc |
| Convert Markdown → HTML | `pandoc file.md -o file.html` | |
| Spell check | `aspell check file.md` | |
| Word count | `wc -w file.md` | |
| Commit docs update | `git commit -m "docs: update <topic>"` | |
| Create GitHub issue | `gh issue create` | Requires GitHub CLI |
| Create GitHub PR | `gh pr create` | |
| View PR status | `gh pr status` | |
| Merge PR | `gh pr merge --squash` | |
