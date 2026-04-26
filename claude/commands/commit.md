---
description: Commit staged changes with a context-focused message
---

Commit the work just performed.

## Arguments
- Any text in $ARGUMENTS is used as the commit subject.

## Workflow

1. Run `git status` to see all changed files.
2. Run `git diff` to understand the unstaged changes and `git diff --staged` for staged ones.
3. Stage the files that are clearly related to a cohesive change using `git add <file>`, based on the work just done. Use your own judgment based on context — do not ask. Leave unrelated changes (e.g., stray untracked files, unrelated edits) alone.
4. Re-run `git diff --staged` to confirm the final commit scope.

## Commit step

Use this commit style:
- Subject: "package: action" in active voice, target <=72 chars.
- Subject must match the actual change; avoid over-claiming.
- Body: explain why the change was needed and any relevant context. Do not list changes.
- Leave a blank line between subject and body.

If $ARGUMENTS is provided, use it as the subject and ensure it matches the style above.
If $ARGUMENTS is empty, derive a subject from the staged diff.

Examples (subjects):
- `math: introduce Sin function`
- `server/models: migrate to UUID v7`

Example (full message):
```
claude: add commit message command

We need a reusable commit helper so commit messages stay consistent
without manual formatting each time.
```

If there are no relevant changes to stage, stop and explain.

Then run:
- git commit -m "<subject>" -m "<body>"

NEVER ask to push the commit or mention pushing in the final response.
