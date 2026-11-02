---
id: dotfiles-ysc
status: open
deps: []
links: []
created: 2026-02-25T12:23:24Z
type: feature
priority: 1
---
# Add cognitive complexity reviewer

Add a code-reviewer variant agent focused specifically on cognitive complexity. The agent should:

1. Analyze functions/methods for cognitive complexity using established metrics (similar to SonarQube's cognitive complexity model): nesting depth, control flow breaks, boolean operator chains, recursion, etc.
2. Flag functions exceeding a configurable threshold (default: 15)
3. For each flagged function, suggest specific refactoring strategies: extract method, replace conditional with polymorphism, early returns, lookup tables, etc.
4. Provide a file-level and repo-level summary with hotspots ranked by complexity score

Implementation: create a new agent definition in claude/agents/ following the existing pattern (YAML frontmatter, tools: Read/Grep/Glob/Bash). Create a corresponding slash command in claude/commands/ that invokes it. The agent should be language-aware and load appropriate guidelines from ~/.claude/guidelines/.
