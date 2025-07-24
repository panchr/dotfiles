# Guidelines
- **Comments**:
  - Prefer to explain "why" rather than "what" in code comments
- **Python**
  - Format all Python code with "black"
- **Go**
  - Format all Go code with "gofmt"

# GitHub CLI Usage
- **Use `gh` CLI for PR management** instead of web interface for consistency and automation
- Common commands:
  - `gh pr view PR_NUMBER` - View PR details
  - `gh pr view PR_NUMBER --comments` - View general PR comments
  - `gh pr list --author username` - List PRs by author
- API commands for line-level comments:
  - `gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments` - View line-level comments with file/line details
  - `gh api repos/OWNER/REPO/pulls/PR_NUMBER/comments --method POST --field body="🤖 **Claude here!** [reply text]" --field in_reply_to=COMMENT_ID` - Reply to line comment (identify as Claude)

