---
description: Address comments from GitHub pull requests
---

<task>
Fetch and address PR feedback comments for the current branch.
Argument: $ARGUMENTS (optional - specific feedback ID or filter)
</task>

<context>
This command fetches PR comments and reviews from the current branch, summarizes feedback, prioritizes issues, and optionally implements fixes through collaborative triage.

Key assumptions:
- The repository may contain uncommitted changes
- Current branch has an associated PR
- Using GitHub CLI (`gh`) for API access, and `gh auth login` has been run prior
- `jq` is available locally
- Comments may be line-specific or general review comments
</context>

<workflow>
Follow these stages strictly in order:

**Stage 1: Pre-flight Checks**
1. Use Bash tool: `git status` to check for outstanding changes
2. If there are staged or unstaged changes, inform user. Never commit on thier behalf
3. Use Bash tool: `gh pr status` to verify current branch has an associated PR

**Stage 2: Fetch PR Feedback**
1. Display: "Fetching PR comments and feedback..."
2. Use Bash tool: `gh api repos/:owner/:repo/pulls/$(gh pr view --json number -q .number)/comments` for line-specific comments
3. Use Bash tool: `gh pr view --json reviews` for review comments
4. Parse comments into structured feedback items (author, type, content, file:line if applicable)
5. Filter out resolved comments and focus on actionable feedback

**Stage 3: Create TODO List**
1. Re-order feedback by severity/impact assessment (highest first)
2. Use TodoWrite tool to add TODOs for each item with severity/impact tags
3. Group similar feedback items together where applicable

**Stage 4: Address Comments**
Fix each TODO item, using the standard code editing process. Make sure to follow any relevant CLAUDE.md files.

**Stage 5: Ask user to review**
1. Tell the user to review, commit, and push the changes to GitHub.
2. Then ask:

```
Shall I reply and resolve all addressed comments on the PR?
Options: (y)es / (s)kip / describe alternative approach
```

3. Wait for user reply before proceeding
4. If user answers yes:
  - Reply to each comment thread that was addressed in Stage 4. Do not start a new comment; reply to the original thread directly. Make sure to prefix your reply with `**Claude here!** [reply text]"`
  - Mark those comments as resolved.
5. If the user answers no:
  - Do nothing else.

</workflow>

<argument_handling>
If $ARGUMENTS is provided, use it to:
- Filter to specific feedback ID or author
- Focus on particular file or area
- Search for specific feedback pattern
If empty, process all available feedback
</argument_handling>

<error_handling>
If no PR found, unclear feedback, or conflicting instructions:
- Ask for clarification before proceeding
- Suggest alternative approaches
- Provide guidance on resolution
</error_handling>

<human_review_needed>
Flag these aspects for verification:
- [ ] Completeness of feedback identification
- [ ] Accuracy of severity assessment
- [ ] Appropriateness of proposed fixes
- [ ] Impact of changes on existing functionality
</human_review_needed>
