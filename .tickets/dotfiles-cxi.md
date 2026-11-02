---
id: dotfiles-cxi
status: open
deps: []
links: []
created: 2026-02-25T12:23:24Z
type: feature
priority: 1
---
# Add code architecture reviewer

Add a code-reviewer variant agent focused on architecture and design quality. The agent should analyze:

1. Dependency structure: circular dependencies, inappropriate coupling between layers/packages, dependency direction violations
2. Module cohesion: files/packages that mix unrelated responsibilities, god objects/files, feature envy
3. API surface: overly broad interfaces, leaky abstractions, inconsistent API patterns across the codebase
4. Code organization: files in wrong directories, inconsistent naming across modules, orphaned/dead code paths
5. Design pattern usage: misapplied patterns, opportunities for well-established patterns that would reduce complexity

For each finding, provide: the issue, why it matters for maintainability, and a concrete refactoring suggestion.

Implementation: create a new agent definition in claude/agents/ following the existing pattern (YAML frontmatter, tools: Read/Grep/Glob/Bash). Create a corresponding slash command in claude/commands/ that invokes it. Should work across Go, Python, JS/TS codebases.
