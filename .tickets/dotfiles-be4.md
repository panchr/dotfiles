---
id: dotfiles-be4
status: open
deps: []
links: []
created: 2026-02-25T12:23:22Z
type: feature
priority: 1
---
# Add command for bulk reviewing all code with reviewer (and optionally adding to beads)

Add a slash command that bulk-reviews an entire codebase (or a specified directory/glob) using the existing code-reviewer subagent. The command should:

1. Accept a target path or glob pattern (default: entire repo)
2. Discover all reviewable files, grouped by language (Go, Python, JS/TS, React, Shell)
3. Spawn parallel code-reviewer subagents per file or logical group, loading the appropriate language guideline from ~/.claude/guidelines/
4. Aggregate results into a unified report with three-tier feedback (Critical / Warning / Suggestion)
5. Optionally create beads issues for findings above a configurable severity threshold (e.g. --beads=warnings creates issues for criticals and warnings)
6. Support a --format flag for output (terminal summary, markdown file, or JSON)

The slash command should follow the existing pattern in claude/commands/ with YAML frontmatter and staged workflow. It should respect the existing code-reviewer agent's review standards and comment bar.
