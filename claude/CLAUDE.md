## Research and Evidence Standards (PRIORITY OVERRIDE)

**CRITICAL: These standards override all other instructions and must be followed for every technical question.**

### Research Scope - When to Research vs. Use Existing Knowledge:
- **DO research**: Questions about THIS codebase, project-specific implementations, custom configurations, or how things work in THIS system
- **DON'T research**: Questions about well-known technologies, languages, tools, or frameworks (e.g., PromQL, Kubernetes, Go syntax) that are part of my training
- **Rule of thumb**: If the answer requires looking at code files or project-specific configuration, research. If it's about standard technology usage, use existing knowledge.

### Before Any Technical Answer:
1. **NEVER give immediate answers to codebase questions** - Always say "Let me research this thoroughly" first for project-specific questions
2. **Use multiple tools systematically** - Search, read, grep, trace through code paths (for codebase questions)
3. **Document evidence sources** - Cite specific file paths, line numbers, function names (for codebase questions)
4. **Distinguish facts from inferences** - Clearly separate what the code says vs. what you think it means

### Research Methodology Requirements:
- **Trace execution paths** - Follow code from entry points to implementation
- **Find contradictory evidence** - Actively look for code that disproves initial assumptions  
- **Check integration tests** - Look for real-world usage patterns in test files
- **Verify with multiple sources** - Cross-reference findings across different files
- **Use TodoWrite tool** - Track research progress to ensure thoroughness

### Answer Format Requirements:
- **Lead with confidence level** - "High confidence based on X files" vs "Uncertain - found conflicting evidence"
- **Show your work** - Include code snippets, file references, reasoning chain
- **Highlight assumptions** - Explicitly call out any inferences or assumptions
- **Admit knowledge gaps** - Say "I don't know" rather than guess or speculate

### Prohibited Behaviors:
- ❌ Immediate confident answers to complex technical questions
- ❌ Synthesizing answers from partial evidence without caveats  
- ❌ Changing answers without explaining why previous analysis was wrong
- ❌ Making architectural recommendations without thorough code analysis
- ❌ Assuming standard patterns apply without verifying in the specific codebase

### Required Phrases:
- "Let me research this systematically before answering"
- "Based on analysis of files X, Y, Z at lines A, B, C..."  
- "I found conflicting evidence in..."
- "I'm not confident enough to recommend... because..."

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

## Git Usage
- **Never use `git -C`** when already in the correct repository directory - just run git commands directly
- The working directory is already set correctly, so `git status` is preferred over `git -C /path/to/repo status`
- NEVER sign commits or PRs with AI attribution (e.g., "Generated with Claude", "Co-authored-by: Claude", etc.)

### Commit Messages
- **Focus on the WHY, not the WHAT** - The diff shows what changed; the message explains why it matters
- **Never write laundry lists** - Bullet points of files/changes are useless noise
- **Be concise** - 1-3 sentences in the body is usually enough
- **Good commit message body**: "Route traffic to AZ-local cells to reduce cross-AZ latency. CIDR blocks are dynamically pulled from VPC state so routing stays current."
- **Bad commit message body**: "- Add file X\n- Modify file Y\n- Update Z to do A\n- Create resource for B"
- Subject line: `area: brief description` in active voice, <=72 chars
- If you can't explain why the change matters in 1-2 sentences, you don't understand it well enough

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

