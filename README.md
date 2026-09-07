# Agent Squad for Codex (OpenAI)

Agent Squad for Codex is a small, evidence-first workflow for project work that needs bounded execution and review. This OpenAI edition pairs the current chat as Lead (Sol Medium/High or Astra Low examples) with one gpt-5.6-luna worker at Max reasoning.

## Route

~~~text
Current chat Lead (Sol Medium/High or Astra Low example)
  -> one Luna Max worker: Build
  -> the same Luna Max worker: Verify
  -> current Lead: Blue/Red Review and Technical Acceptance
  -> user operational feedback
~~~

Sol Medium/High and Astra Low are examples of Lead settings, not a claim that models are equal or a requirement to use one. The actual visible model and reasoning metadata is authoritative. A UI model switch changes subsequent Lead turns; this workflow cannot lock or automatically revert it.

The current chat handles understanding, planning, discussion, copy review, and review-only work without spawning. When implementation is needed, it delegates exactly one luna_worker. There are no extra planner or reviewer agents, parallel workers, or nested delegation. Same-worker verification is useful evidence, but it is not independent testing.

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

Invoke the skill with $agent-squad for a task that needs a bounded worker. The Lead should declare the route before tool-heavy work and record actual model evidence or mark it user-reported/unverified.

If Luna is unavailable, report the actual blocker and retain any partial work and handoff. Do not silently substitute another model or worker. Consequential actions still require existing user authorization; technical acceptance is not production approval.

## No-write smoke test

After installation, use a disposable task and send:

~~~text
Use $agent-squad for a no-write delegation smoke test. Keep the current chat as Lead, use exactly one Luna Max worker to return "worker-ok", then send a distinct verification follow-up to that same worker and have it return "verify-ok". Perform the Lead blue/red review and report the observed model and reasoning metadata. Do not create or modify files or external systems.
~~~

Expected evidence is one bounded Luna worker, the explicitly requested distinct same-worker verification follow-up, no planner/reviewer/second-worker thread, and a Lead report that distinguishes technical acceptance from consequential authorization. If the runtime cannot launch Luna, stop and report the actual discovery or capacity issue.

## Contents

~~~text
agent-squad/SKILL.md
agent-squad/agents/openai.yaml
codex-agents/luna-worker.toml
install.sh
~~~

The package contains no credentials, personal paths, histories, or provider fallbacks.

## Download

[Download the curated OpenAI package](https://raw.githubusercontent.com/arbiger/agent-squad/main/downloads/agent-squad-codex-openai-2026-09-07.zip)

## Optional Superpowers

Superpowers can be used when installed and relevant, but it is optional. It does not add agents or change the one-worker route.
