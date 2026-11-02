---
description: Loop through ready tk tickets and commit
---

Repeatedly pop ready tickets from tk using `tk ready`, complete each ticket, and create well-scoped commits.

## Arguments
- Instructions on specific types of tickets to focus on. If given, only work on those tickets (`tk ready -T <tag>` filters by tag).
- A ticket count (e.g. "do 10 tasks"). If given, use it as the checkpoint interval instead of the default of 5.
- "all tasks" (or similar): run until the queue is empty without pausing at checkpoints.

## Workflow
1. Run `tk ready` and take the first ticket (it is sorted by priority), then read it in full with `tk show <id>`.
2. If no ticket is returned, stop and report that the queue is empty.
3. Mark the ticket as in-progress immediately, before starting: `tk start <id>`.
4. Execute the ticket end-to-end following repo conventions and any CLAUDE.md instructions. **IMPORTANT**: do not ask if the ticket should be done, go ahead and do it.
5. Record what shipped with `tk add-note <id> "<summary>"`, then `tk close <id>`: tk keeps no close reason of its own.
6. Stage only the files that belong to the ticket, including its file in `.tickets/`. If unsure, ask before staging.
7. Create a single, well-scoped commit for the ticket.
   - Use the commit style described in the `/commit` command.
8. Repeat from step 1.

## Large-scope tickets
If a ticket is large in scope (large feature or epic), break it down into smaller subtasks before implementation.
- Use the `@research` subagent to draft the breakdown.
- Create each subtask from the repository root with `tk create "<title>" -d "<context>" --parent <id>`, and order them with `tk dep <later> <earlier>`.
- Resume the loop with `tk ready` after subtasks are created.

## Task checkpoint
Skip checkpoints entirely if the user asked for all tasks; only summarize at the end.

After every N completed tickets (default 5, or whatever count the user specified in the arguments or conversation):
- Pause and prompt the user to review the work before continuing.
- Provide a short summary of what changed in those tickets.
- Include how the *user* can verify the work: any tests to run, UIs to look at, etc.
- Wait for confirmation to proceed with the next `tk ready`.
