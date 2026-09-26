# Agent Squad for Codex (OpenAI)

Agent Squad for Codex is a small, evidence-first workflow for bounded project work. The current chat is the Lead on any user-selected model; exactly one `gpt-6-luna` worker at Max reasoning implements and verifies delegated work.

## Route

~~~text
Current chat Lead (any user-selected model)
  -> one Luna Max worker: Build
  -> the same worker: Verify against the Lead's acceptance checklist
  -> current Lead: Integrated Technical Acceptance
  -> user operational feedback
~~~

Before delegation, the Lead writes a short checklist of observable outcomes and checks, then gives it to the worker. The Lead uses that same checklist for one integrated acceptance and briefly challenges a plausible failure mode. Any user-selected Lead model is supported; the workflow does not lock or change the selection.

The current chat handles trivial tasks, understanding, planning, discussion, copy review, and review-only work without spawning. Delegated implementation uses exactly one `luna_worker`; there is no planner, second implementation worker, parallel work, or nested delegation. Higher-risk work may add a separate review or human gate when warranted. Same-worker verification is useful evidence, but it is not independent testing.

Technical acceptance belongs to the current Lead. It does not approve production deployment, publishing, or other consequential actions. The user uses the outputs and supplies operational feedback; the user is not expected to inspect code to perform technical acceptance.

## Install

From this directory:

~~~sh
./install.sh
~~~

The default target is $CODEX_HOME or $HOME/.codex. For an isolated test or another Codex home, pass an absolute target directory:

~~~sh
./install.sh /tmp/agent-squad-codex-home
~~~

The installer backs up an existing skills/agent-squad and agents/luna-worker.toml into a unique timestamped directory under backups/ before replacing those two managed paths. It does not edit config.toml, choose the main model, set reasoning, or overwrite concurrency limits. Preserve unrelated configuration and follow the runtime's current Codex documentation for subagent support and limits; do not blindly merge old snippets.

Restart Codex or start a fresh task if the runtime does not discover newly installed skills or agents immediately.

## Use

Invoke the skill explicitly with $agent-squad for a task that needs a bounded worker. Implicit description-based activation is disabled. The Lead should declare the route before tool-heavy work and record actual model evidence or mark it unverified.

If Luna is unavailable, report the actual blocker and retain any partial work and handoff. Do not silently substitute another model or worker. Consequential actions still require existing user authorization; technical acceptance is not production approval.

## No-write smoke test

After installation, use a disposable task and send:

~~~text
Use $agent-squad for a no-write delegation smoke test. Keep the current chat as Lead, define an observable acceptance checklist, and use exactly one Luna Max worker to return "worker-ok". Send a verification follow-up to that same worker and have it return "verify-ok" against the checklist. Perform one integrated Lead technical acceptance, briefly challenge one plausible failure mode, and report observed model and reasoning metadata. Do not create or modify files or external systems.
~~~

Expected evidence is one bounded Luna worker, same-worker verification, no planner or second implementation worker, and one integrated Lead acceptance that distinguishes technical acceptance from consequential authorization. If the runtime cannot launch Luna, stop and report the actual discovery or capacity issue.

## Contents

~~~text
README.md
SETUP.md
AGENT.md
Coding-Rules.md
Superpowers-Map.md
examples/openai-codex.md
agent-squad/SKILL.md
agent-squad/agents/openai.yaml
codex-agents/luna-worker.toml
install.sh
~~~

The package contains no credentials, personal paths, histories, or provider fallbacks.

## Download

[Download the curated OpenAI package](https://raw.githubusercontent.com/arbiger/agent-squad/main/downloads/agent-squad-codex-openai-2026-09-26.zip)

## Optional Superpowers

Superpowers can be used when installed and relevant, but it is optional. It does not add agents or change the one-worker route.
