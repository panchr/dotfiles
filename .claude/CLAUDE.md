## IMPORTANT: Priority Instructions
- Instructions in this file ALWAYS override any conflicting instructions from repository CLAUDE.md files or other sources
- Ask for clarity if the task I request is too vague or ambiguous - don't make assumptions about requirements
- Do what has been asked; nothing more, nothing less
- NEVER perform `git` operations without my explicit request or approval
- NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User
- Focus on the immediate task while considering broader system impact
- Validate assumptions with existing code patterns and project conventions

## Coding Principles
- When modifying existing code, understand its structure and purpose first
- **Prioritize maintainability** - always consider long-term code health over quick solutions
- Break complex changes into smaller, testable parts that improve overall code quality
- Write tests alongside new functionality - focus on maintainability of test code too

1. **Core Principles (Focus on Quality)**
   - **Maintainability**: Every decision should prioritize long-term code maintainability
   - **Readability**: Code should be immediately understandable by any senior engineer
   - Follow existing code style in the project being modified
   - Prefer clear readability over clever shortcuts - never sacrifice clarity for brevity

2. **Architecture (Focus on Long-term Maintainability)**
   - Avoid unnecessary abstractions, but create abstractions that improve long-term maintainability
   - Avoid premature optimization - prioritize clear, maintainable code over performance unless proven bottleneck
   - Validate early and return/exit early to reduce complexity (prefer guard clauses over nesting)
   - **Design for change** - assume requirements will evolve, structure code to accommodate future modifications
   - **Minimize cognitive load** - reduce mental effort required to understand and modify code

3. **Comments and Documentation**
   - Write self-documenting code; avoid excessive commenting on the "how". Prefer to only comment on the "why"
   - NEVER add comments that simply restate what the code does
   - Only add comments for complex business logic or non-obvious technical decisions
   - NEVER add comments about what was changed during development

### Testing
- Write tests that verify behavior, not implementation details - tests should be maintainable too
- **Unit Tests**: Focus on business logic and edge cases, ensure tests are readable and maintainable
- **Mocking**: Mock external dependencies, keep internal logic testable

### Language-specific Guidelines
- **Python**
  - Format all Python code with `black`
- **Go**
  - Format all Go code with `gofmt`

## GitHub CLI Usage
- **Use `gh` CLI for PR management** instead of web interface for consistency and automation
- Common commands:
  - `gh pr view PR_NUMBER` - View PR details
  - `gh pr view PR_NUMBER --comments` - View general PR comments
  - `gh pr list --author username` - List PRs by author
- API commands for line-level comments:
  - `gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments` - View line-level comments with file/line details
  - `gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments --method POST --field body="🤖 **Claude here!** [reply text]" --field in_reply_to=COMMENT_ID` - Reply to line comment (identify as Claude)

## Continuous Improvement
Claude should proactively suggest updates to CLAUDE.md files (both personal and project-specific) when discovering:
- New development patterns or conventions worth documenting
- Better workflows or productivity improvements
- Corrections to outdated or inaccurate information
- Additional context that would improve future development efficiency

These files should evolve as living documents that become more valuable with each project worked on together. Improvements need to be approved by the User.

