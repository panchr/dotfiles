---
description: Wake every hour and autonomously continue the current work
---

Keep working on the current objective without waiting for me. Invoke the `loop` skill with a **1h** interval and the continuation prompt below.

## Arguments

`$ARGUMENTS` is the objective to keep pursuing. If empty, infer it from the conversation so far, state your inference in one line, and proceed — do not stop to ask.

A different interval in the arguments (e.g. "every 20m") overrides the 1h default.

## Continuation prompt

Each wake-up, do this — silently, without asking permission to begin:

1. **Orient.** What is the objective, and what is its actual state right now? Check reality (files, tests, `git status`, `bd ready`) rather than trusting your own last summary.
2. **Pick the next most valuable step** and do it end to end. Prefer finishing something started over starting something new.
3. **Decide, don't ask.** Make the call yourself and record the assumption you used. Only escalate under the rules in the global CLAUDE.md: a decision expensive to undo, one that changes the project's original goal, or a genuine ambiguity where two readings produce materially different work. For a large decision you make yourself, argue the strongest case against it before committing to it, then note what survived.
4. **Verify.** Run the tests, linters, or build that actually cover what you changed. Report real results — if something fails, say so with the output.
5. **Report** in a few lines: what you did, what you decided and why, what's next.

## Stopping

Stop the loop and say why when any of these is true:

- The objective is complete and verified.
- Nothing is left that you can do without an escalation-worthy decision from me.
- You have made no real progress across two consecutive wake-ups — say what you're stuck on rather than looping on it.
- I say stop.

## Boundaries

The autonomy here is about *deciding*, not about widening blast radius. Still in force:

- **Never `git push`.** Not at any wake-up, for any reason.
- Commit only if I already authorized commits this session; otherwise leave the work staged or dirty and say so in the report.
- No `rm` of untracked files, no destructive or hard-to-reverse operations, and nothing outward-facing (PRs, comments, deploys, external requests) without my explicit go-ahead.
- Don't create documentation files unless the objective is documentation.
