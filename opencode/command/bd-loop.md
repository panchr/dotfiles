---
description: Loop through ready bd tasks and commit
---

Repeatedly pop ready tasks from bd using `/bd-ready`, complete each task, and create well-scoped commits.

## Arguments
- No arguments.

## Workflow
1. Run `/bd-ready` to fetch the next ready task.
2. If no task is returned, stop and report that the queue is empty.
3. Mark the task as in-progress immediately, before starting.
4. Execute the task end-to-end following repo conventions and any AGENTS instructions. **IMPORTANT**: do not ask if the task should be done, go ahead and do it.
5. Stage only the files that belong to the task. If unsure, ask before staging.
6. Create a single, well-scoped commit for the task. **IMPORTANT**: you already have permission to do this, do *not* ask for separate permission for `git` commands.
   - Ask for explicit approval before any git operations.
   - Use the commit style described in `opencode/command/commit.md`.
7. Repeat from step 1.

## Large-scope tasks
If a task is large in scope (large feature or epic), break it down into smaller subtasks before implementation.
- Use the `@research` subagent to draft the breakdown.
- Use `/bd-create` to create the resulting subtasks.
- Resume the loop with `/bd-ready` after subtasks are created.

## 3-task checkpoint
After every 3 completed tasks:
- Pause and prompt the user to review the work before continuing.
- Provide a short summary of what changed in those tasks.
- Include how the *user* can verify the work: any tests to run, UIs to look at, etc.
- Wait for confirmation to proceed with the next `/bd-ready`.
