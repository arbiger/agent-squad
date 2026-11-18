# Compare Terra Low And Luna Max

Start with three representative tasks: a small fix, a cross-file change, and a failing test investigation. For each task, create two isolated worktrees at the same commit and use fresh chats with the same Lead model and reasoning. Use the same brief, scope, checklist, tools, and time budget. Keep each run's output out of the other chat.

Run `$agent-squad-terra` in one chat and `$agent-squad` in the other. This compares the two workflows as used. For a model-only comparison, give both workers identical instructions and change only the worker model and reasoning setting.

Record model/effort, first-pass acceptance, failed checks or regressions, rework rounds, and elapsed time through acceptance. Record usage only if observable per run. Use the same tests and acceptance criteria for both diffs, and hide worker labels during review when practical.

Prefer Terra for the tested task class if it meets the same quality bar with no extra rework and saves elapsed time or observed usage. Treat three cases as a pilot; expand the sample if results are mixed.
