---
id: dotfiles-kn6
status: open
deps: []
links: []
created: 2026-02-25T12:23:23Z
type: feature
priority: 1
---
# Add slash command for finding testing gaps in code (and optionally adding to beads)

Add a slash command that analyzes a codebase to identify testing gaps. The command should:

1. Accept a target path or glob pattern (default: entire repo)
2. Discover all source files and their corresponding test files using common conventions (e.g. foo.go -> foo_test.go, bar.py -> test_bar.py, baz.ts -> baz.test.ts)
3. Identify files with no corresponding tests at all
4. For files with tests, use a subagent to analyze coverage gaps: untested functions, missing edge cases, untested error paths, missing integration scenarios
5. Produce a prioritized report: files with no tests first, then files with significant gaps, then minor suggestions
6. Optionally create beads issues for the gaps (--beads flag), grouped logically (one issue per file or per module)
7. Support filtering by language or directory

Should follow the existing slash command pattern in claude/commands/ with YAML frontmatter and staged workflow.
