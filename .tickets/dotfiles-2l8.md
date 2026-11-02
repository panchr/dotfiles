---
id: dotfiles-2l8
status: open
deps: []
links: []
created: 2026-02-25T12:23:23Z
type: feature
priority: 1
---
# Add command for simplifying CLAUDE.md

Add a slash command that analyzes and simplifies CLAUDE.md files (both global ~/.claude/CLAUDE.md and project-level). The command should:

1. Read the target CLAUDE.md file(s)
2. Identify redundancies: instructions that duplicate Claude's default behavior, overly verbose explanations, repeated concepts across sections
3. Identify conflicts: instructions that contradict each other or contradict defaults
4. Identify dead weight: instructions about features/patterns no longer in use, references to nonexistent files or tools
5. Suggest a simplified version that preserves all meaningful intent in fewer lines
6. Present a diff of proposed changes for user approval before applying
7. Support --dry-run to show suggestions without modifying anything

Goal: keep CLAUDE.md files concise and high-signal. Lines after 200 in memory files get truncated, and verbose instructions waste context window. Every line should earn its place.
