# Agent Instructions

This project uses **tk** ([wedow/ticket](https://github.com/wedow/ticket)) for issue tracking. Run `tk help` to get started.

## Quick Reference

```bash
tk ready              # Find available work
tk show <id>          # View ticket details
tk start <id>         # Claim work
tk close <id>         # Complete work
```

## Non-Interactive Shell Commands

**ALWAYS use non-interactive flags** with file operations to avoid hanging on confirmation prompts.

Shell commands like `cp`, `mv`, and `rm` may be aliased to include `-i` (interactive) mode on some systems, causing the agent to hang indefinitely waiting for y/n input.

**Use these forms instead:**
```bash
# Force overwrite without prompting
cp -f source dest           # NOT: cp source dest
mv -f source dest           # NOT: mv source dest
rm -f file                  # NOT: rm file

# For recursive operations
rm -rf directory            # NOT: rm -r directory
cp -rf source dest          # NOT: cp -r source dest
```

**Other commands that may prompt:**
- `scp` - use `-o BatchMode=yes` for non-interactive
- `ssh` - use `-o BatchMode=yes` to fail instead of prompting
- `apt-get` - use `-y` flag
- `brew` - use `HOMEBREW_NO_AUTO_UPDATE=1` env var
- `tk edit` - opens `$EDITOR`; edit the ticket file in `.tickets/` directly instead

## Issue Tracking with tk

**IMPORTANT**: This project uses **tk** for ALL issue tracking. Do NOT use markdown TODOs, task lists, or other tracking methods.

tk is one bash script with no database or daemon, installed by `misc/mise.toml`. Each ticket is a markdown file with YAML frontmatter in `.tickets/` at the repository root, named by its id, so a ticket is read with `tk show <id>` or by opening the file. Commit ticket files in the same commit as the change that opened, updated or closed them. `tk` finds `.tickets/` from any subdirectory, but run `tk create` from the repository root: it takes a new id's prefix from the current directory's name (`dot-` at the root).

### Why tk?

- Dependency-aware: Track blockers and relationships between tickets
- Git-friendly: one markdown file per ticket, versioned and merged alongside the code
- Agent-friendly: `tk query` emits JSON, `tk ready` finds unblocked work
- Prevents duplicate tracking systems and confusion

### Quick Start

**Check for ready work:**

```bash
tk ready
```

**Create new tickets:**

```bash
tk create "Ticket title" -d "Detailed context" -t bug|feature|task -p 0-4 --tags zsh
tk create "Found bug" -d "What this is about. Discovered from <parent-id>." -p 1
```

**Claim and update:**

```bash
tk start <id>
tk dep <id> <blocker-id>      # <id> waits on <blocker-id>
tk link <id> <other-id>       # related tickets (symmetric)
```

To change a field tk has no command for, such as `priority`, edit the ticket's frontmatter.

**Complete work:**

```bash
tk add-note <id> "Completed"
tk close <id>
```

### Issue Types

- `bug` - Something broken
- `feature` - New functionality
- `task` - Work item (tests, docs, refactoring)
- `epic` - Large feature with subtasks
- `chore` - Maintenance (dependencies, tooling)

### Priorities

- `0` - Critical (security, data loss, broken builds)
- `1` - High (major features, important bugs)
- `2` - Medium (default, nice-to-have)
- `3` - Low (polish, optimization)
- `4` - Backlog (future ideas)

### Workflow for AI Agents

1. **Check ready work**: `tk ready` shows unblocked tickets
2. **Claim your task**: `tk start <id>`
3. **Work on it**: Implement, test, document
4. **Discover new work?** Create a ticket and link it to the one you found it from:
   - `tk create "Found bug" -d "Details about what was found. Discovered from <parent-id>." -p 1`, then `tk link <new-id> <parent-id>`
5. **Complete**: `tk add-note <id> "Done"`, then `tk close <id>`

### Important Rules

- ✅ Use tk for ALL task tracking
- ✅ Use `tk query` (JSON, filtered with jq) for programmatic use
- ✅ Link discovered work back to where it came from
- ✅ Check `tk ready` before asking "what should I work on?"
- ✅ Record why a ticket closed with `tk add-note` before `tk close`: tk keeps no close reason of its own
- ❌ Do NOT create markdown TODO lists
- ❌ Do NOT use external issue trackers
- ❌ Do NOT duplicate tracking systems

### Migrated from beads

The tracker moved from beads (bd) to tk, keeping every issue's id, so commits that name an id such as `dotfiles-6ga` still resolve to `.tickets/dotfiles-6ga.md`. Each closed ticket's close reason is the last entry under its `## Notes`.

## Landing the Plane (Session Completion)

**When ending a work session:**

1. **File tickets for remaining work** - Create tickets for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update ticket status** - Close finished work, update in-progress items
4. **Clean up** - Clear stashes, prune remote branches
5. **Hand off** - Provide context for next session
