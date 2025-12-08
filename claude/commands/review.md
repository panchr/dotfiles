---
description: Review code changes for Go style adherence using Effective Go guidelines
---

<task>
Review code for Go style adherence and optionally post comments on a GitHub PR.
Argument: $ARGUMENTS (optional - GitHub PR URL to review)
</task>

<context>
This command reviews Go code changes against Effective Go style guidelines. It can operate in two modes:
1. **Local mode**: Review uncommitted changes or recent commits in the current branch
2. **PR mode**: When given a GitHub PR URL, fetch the PR diff, review it, and prepare line-specific comments

Key assumptions:
- Using GitHub CLI (`gh`) for API access when reviewing PRs
- `gh auth login` has been run prior
- The style-reviewer agent is available for detailed style analysis
</context>

<workflow>
Follow these stages strictly in order:

**Stage 0: Determine Mode**
1. Check if $ARGUMENTS contains a GitHub PR URL (matches pattern `github.com/.*/pull/\d+` or similar)
2. If PR URL provided → proceed with PR Review Mode (Stage 1A)
3. If no arguments or non-URL argument → proceed with Local Review Mode (Stage 1B)

---

## PR Review Mode

**Stage 1A: Fetch PR Information**
1. Parse the PR URL to extract owner, repo, and PR number
2. Use Bash tool: `gh pr view <PR_URL> --json number,title,body,headRefName,baseRefName` to get PR metadata
3. Use Bash tool: `gh pr diff <PR_URL>` to get the full diff
4. Display: "Reviewing PR #<number>: <title>"

**Stage 2A: Analyze Changes**
1. Parse the diff to identify modified Go files (*.go)
2. For each modified Go file:
   - Extract the changed lines and their line numbers
   - Read surrounding context if needed for understanding
3. Apply the style-reviewer guidelines to analyze:
   - Naming conventions
   - Error handling patterns
   - Concurrency patterns
   - Control flow (happy path left-aligned)
   - Interface design
   - Comment quality (VERY HIGH BAR)
   - Critical patterns (goroutine leaks, resource leaks, race conditions, error ignoring, context misuse)

**Stage 3A: Prepare Draft Comments**
1. For each style issue found, prepare a draft comment with:
   - File path
   - Line number (use the NEW file line number from the diff)
   - Side: "RIGHT" (for additions) or "LEFT" (for context/deletions being referenced)
   - Comment body with:
     - Clear description of the issue
     - Reference to Effective Go guideline if applicable
     - Suggested fix or improvement
2. Categorize comments by severity:
   - **Critical**: Must fix (goroutine leaks, race conditions, error ignoring)
   - **Warning**: Should fix (naming, error handling patterns)
   - **Suggestion**: Consider improving (style enhancements)

**Stage 4A: Present Comments for Approval**
1. Display all prepared comments to the user in a clear format:
   ```
   === Draft PR Comments ===

   [CRITICAL] file.go:42
   > Issue description
   > Suggested fix

   [WARNING] other.go:15
   > Issue description
   > Suggested fix

   [SUGGESTION] util.go:88
   > Enhancement idea
   ```
2. Ask user:
   ```
   Ready to post these comments as a review on the PR?
   Options:
   - (y)es - Post all comments
   - (s)elect - Let me choose which to post
   - (n)o - Cancel, don't post
   ```
3. Wait for user response

**Stage 5A: Post Comments**
1. If user says yes:
   - Get the latest commit SHA: `gh pr view <PR_URL> --json headRefOid -q .headRefOid`
   - For each comment, use the GitHub API to post as a review comment:
     ```
     gh api repos/<owner>/<repo>/pulls/<pr_number>/comments \
       --method POST \
       -f body="<comment_body>" \
       -f commit_id="<commit_sha>" \
       -f path="<file_path>" \
       -F line=<line_number> \
       -f side="RIGHT"
     ```
   - Alternatively, batch all comments into a single review:
     ```
     gh api repos/<owner>/<repo>/pulls/<pr_number>/reviews \
       --method POST \
       -f event="COMMENT" \
       -f body="Style review based on Effective Go guidelines" \
       --input <json_file_with_comments>
     ```
2. If user says select:
   - Present each comment individually for approval
   - Post only approved comments
3. If user says no:
   - Display: "Review cancelled. No comments posted."

---

## Local Review Mode

**Stage 1B: Check Local Changes**
1. Use Bash tool: `git status` to check for uncommitted changes
2. Use Bash tool: `git diff` to see unstaged changes
3. Use Bash tool: `git diff --cached` to see staged changes
4. If no changes found, check recent commits: `git log -5 --oneline`

**Stage 2B: Review Changes**
1. Identify modified Go files from the diff
2. Apply the style-reviewer guidelines to analyze all changes
3. Check for:
   - Naming conventions (packages, variables, functions)
   - Struct/interface design patterns
   - Function complexity and indentation (happy path left-aligned)
   - Unnecessary abstractions
   - Parameter style
   - Testing patterns (table tests)
   - Prohibited patterns (global vars, init functions, panic)
   - Effective / Idiomatic Go
   - Code readability
   - Critical patterns (goroutine leaks, resource leaks, race conditions)

**Stage 3B: Present Findings**
1. Output findings in the standard style-reviewer format:

   **Critical Issues** (must fix before commit):
   - [File:Line] Issue description + how to fix

   **Warnings** (should fix):
   - [File:Line] Issue description + suggestion

   **Suggestions** (consider improving):
   - [File:Line] Enhancement idea

2. If code follows style guidelines well, confirm and highlight good patterns

</workflow>

<style_reference>
Apply guidelines from the style-reviewer agent, which covers:
- Effective Go (https://go.dev/doc/effective_go)
- Naming: MixedCaps, short package names, no Get prefix for getters
- Formatting: gofmt, tabs for indentation
- Control flow: happy path left-aligned, early returns
- Error handling: return errors as values, use comma-ok idiom
- Concurrency: share by communicating, proper channel usage
- Comments: VERY HIGH BAR - only for complex algorithms, non-obvious business rules, performance considerations, security implications, subtle workarounds, magic numbers, or TODOs
</style_reference>

<argument_handling>
$ARGUMENTS can be:
- Empty: Review local uncommitted changes
- GitHub PR URL: Review that specific PR and prepare comments
- Commit SHA or range: Review those specific commits locally
</argument_handling>

<error_handling>
- If PR URL is invalid or inaccessible: Ask user to verify URL and permissions
- If no Go files in changes: Report "No Go files found in changes"
- If gh CLI not authenticated: Prompt user to run `gh auth login`
- If API rate limited: Inform user and suggest waiting
</error_handling>
