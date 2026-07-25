---
description: Commit staged changes with a context-focused message
---

Commit the work just performed. `$ARGUMENTS`, if present, is the commit subject.

## Staging

1. `git status`, then `git diff` and `git diff --staged` to understand what changed.
2. Stage the files belonging to one cohesive change with `git add <file>`. Judge from the work just done — do not ask. Leave unrelated edits and stray untracked files alone.
3. Re-run `git diff --staged` to confirm the scope.

If there's nothing relevant to stage, stop and explain.

## Message

- Subject: `package: action`, active voice, <=72 chars. It must match what actually changed — don't over-claim.
- Blank line, then body: why the change was needed. Never list the changes; the diff already shows them.
- Derive the subject from the staged diff if `$ARGUMENTS` is empty; otherwise use `$ARGUMENTS`, conformed to the style above.

Subject examples: `math: introduce Sin function`, `server/models: migrate to UUID v7`

Full example:

```
claude: add commit message command

We need a reusable commit helper so commit messages stay consistent
without manual formatting each time.
```

## Commit

Run `git commit -m "<subject>" -m "<body>"`.

NEVER push, ask to push, or mention pushing in the final response.
