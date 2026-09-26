# Agent Squad for Codex Setup

This package targets Codex with the current chat as Lead on any user-selected model and one `gpt-6-luna` execution worker at Max reasoning. It does not set the main model or overwrite runtime limits. Skill activation is explicit only.

## 1. Install

Run the installer from the package directory:

~~~sh
./install.sh
~~~

For a disposable target:

~~~sh
./install.sh /tmp/agent-squad-codex-home
~~~

The first argument is the target Codex home. If omitted, the installer uses $CODEX_HOME or $HOME/.codex.

Before replacing managed files, the installer moves any existing skill or Luna agent into a collision-safe timestamped backup below <target>/backups/. It leaves unrelated files in place and never edits <target>/config.toml.

## 2. Check runtime support

Use the Codex version and documentation available in the target environment to confirm custom-agent and subagent support. Runtime-specific concurrency limits may differ. Do not copy an old config snippet or blindly overwrite the user's chosen model, reasoning, or concurrency settings.

The package does not select, lock, or change the Lead model. The current chat model and reasoning are chosen by the user or runtime.

## 3. Run a no-write smoke test

Use a fresh disposable task:

~~~text
Use $agent-squad for a no-write delegation smoke test. Keep the current chat as Lead, define an observable acceptance checklist, and use exactly one Luna Max worker to return "worker-ok". Send a verification follow-up to that same worker and have it return "verify-ok" against the checklist. Perform one integrated Lead technical acceptance, briefly challenge one plausible failure mode, and report the observed model and reasoning metadata. Do not create or modify files or external systems.
~~~

Confirm from runtime evidence:

- one bounded luna_worker was used
- the worker is Luna Max according to delegation metadata
- any verification follow-up went to the same worker
- no planner or second implementation worker was created
- the Lead reported checklist results, one integrated acceptance, a plausible failure mode, and remaining authorization gates

Same-worker verification is not independent testing. If Luna cannot be discovered or launched, report that blocker instead of substituting another model.

## 4. Operate safely

The Lead may handle trivial, discussion, and review-only work without spawning. For delegated implementation, the Lead first writes an observable acceptance checklist and includes it in the Luna handoff along with goal, background, allowed files or artifacts, non-goals, required changes, verification, forbidden actions, evidence, and escalation triggers.

Return fixes to the same Luna worker. Keep the worker within coding, copywriting, testing, or debugging. Do not silently expand into architecture, security, credentials, permissions, migrations, deployment, compliance, regulatory, or business decisions.

The current Lead performs one integrated technical acceptance and briefly challenges a plausible failure mode. Higher-risk work may add separate review or a human gate when warranted. Technical acceptance does not approve production or external actions. Use existing user authorization for consequential actions and do not re-ask for an action already authorized.

For substantial implementation or durable decisions, update the project's existing DEV-LOG.md. Create or update a HANDOFF only for unfinished, blocked, paused, or transferred work; do not duplicate sources of truth or write secrets.
