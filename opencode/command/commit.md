---
description: Commit staged changes with a context-focused message
---
Commit the currently staged changes.

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
- git commit -m "<subject>" -m "<body>"
