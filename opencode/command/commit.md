---
description: Commit staged changes with a context-focused message
---

Commit the currently staged changes.

## Arguments
- `--stage`: Stage all relevant changed files before committing. If unsure whether a file is relevant, ask.
- Any other text in $ARGUMENTS is used as the commit subject.

## Workflow

**If `--stage` is in $ARGUMENTS:**
1. Run `git status` to see all changed files
2. Run `git diff` to understand the unstaged changes
3. Stage files that are clearly related to a cohesive change using `git add <file>`
4. If unsure whether a file belongs in this commit, ask before staging
5. Continue to the commit step below

**Commit step:**

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
opencode: add commit message command

We need a reusable commit helper so commit messages stay consistent
without manual formatting each time. This adds the command and ensures
init links the command directory so it is installed with the rest of the
OpenCode config.
```

Before committing, run:
- git status
- git diff --staged

If there are no staged changes, stop and explain.

Then run:
- git commit -m "<subject>" -m "<body>**

NEVER ask to push the commit.

