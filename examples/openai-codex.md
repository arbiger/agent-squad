# OpenAI Codex Route

The Lead may use any model selected by the user or runtime. The Luna worker is fixed by this package.

~~~text
Lead: current chat on the user-selected model
Plan: Lead writes a short, observable acceptance checklist
Build and verify: one GPT-6 Luna Max custom worker
Acceptance: one integrated Lead technical acceptance against the checklist
Challenge: Lead briefly considers a plausible failure mode
Feedback: user operational feedback and new authorization only when a consequential gate is reached
~~~

The current chat handles trivial, discussion, and review-only work without spawning. It delegates one bounded coding, copywriting, testing, or debugging assignment when implementation is needed. There is no planner, second implementation worker, nested delegation, fallback model, automatic model switch, or fixed Lead model. A separate review or human gate may be added for higher-risk work when warranted.

Record actual visible model and reasoning metadata, or mark it user-reported/unverified. A UI model switch changes subsequent Lead turns and this skill cannot lock or automatically revert it.

The Luna handoff must state goal, background, allowed files or artifacts, non-goals, required changes, acceptance checklist, verification, forbidden actions, evidence, and escalation triggers. Same-worker verification is not independent testing. If Luna is unavailable, report the actual blocker and retain partial work and handoff; do not substitute another model.
