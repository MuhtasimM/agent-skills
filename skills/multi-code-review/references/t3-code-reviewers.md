# Running reviewers through T3 Code

Read this when the review runs inside T3 Code. It covers checking which subscriptions are available, launching reviewers on pinned models, and waiting for them.

## Check subscriptions

Call `orchestrator_capabilities` once. Its `providers` list is the source of truth for subscriptions. A provider entry counts as usable when `canRunChildTask` is `true` and its `constraints` list is empty or does not mark it disabled.

| Subscription | Usable when a provider has | Reviewer target |
| --- | --- | --- |
| Claude | `driverKind: "claudeAgent"` and model `claude-opus-5-5` | `model: "claude-opus-5-5"`, `options: {effort: "high"}` |
| Codex | `driverKind: "codex"` and model `gpt-6.1-sol` | `model: "gpt-6.1-sol"`, `options: {reasoningEffort: "high"}` |

The model list in each entry is short. If the model is not listed and `omittedModels` is above zero, call `orchestrator_capabilities` with `search` set to the model id before you decide the model is unavailable.

Only the `codex` driver counts as the Codex subscription. Another provider can list a GPT model under a different id (for example `openai/gpt-6.1-sol` on `pi`), but that provider bills a different account, so do not use it as a substitute.

Several Claude instances can qualify (for example `claudeAgent`, `claudeAgent_claude_2`). Use `inheritedProviderInstanceId` when it is one of them. Otherwise use the first qualifying instance in the list. Put the chosen id in `target.providerInstanceId`.

Pick the reviewer models from the result:

- Claude only: five reviewers on Opus 5.5, high effort.
- Codex only: five reviewers on GPT-6.1 Sol, high reasoning effort.
- Both: ten reviewers. Each axis gets one Opus 5.5 reviewer and one GPT-6.1 Sol reviewer.
- Neither: tell the user which providers you found and why none qualified, then run the five reviewers as native subagents in the current session. Record this under Verification.

## Launch reviewers

Start every reviewer with `delegate_task`, including reviewers on your own provider, so each one runs on the pinned model and effort:

- `task`: the full reviewer brief (see below)
- `title`: `<axis>-reviewer (<model>)`, for example `security-reviewer (gpt-6.1-sol)`
- `role`: `"review"`
- `mode`: `"async"`
- `isolation`: `"shared"`, so the reviewer reads the same checkout as you
- `target`: `providerInstanceId`, `model`, and `options` from the table above

Leave `runtimeMode` and `interactionMode` unset. Launch all reviewers in one message so they run in parallel.

A `delegate_task` child starts with no parent history and may not have this skill installed. Make each `task` self-contained:

- the shared review packet, with the absolute repository path and the exact commands that reproduce the diff
- the reviewer's axis section from `references/review-axes.md`, pasted in full
- for the security and performance reviewers, the absolute path of `references/security-checklist.md` or `references/performance-checklist.md`, with an instruction to read it completely
- the required finding format from `SKILL.md`
- an instruction to stay read-only, start no subagents, and end with the finding format as the final message

Keep the `taskId` from every launch.

## Wait and collect

Each `delegate_task` result carries a `next` field. Follow it to wait for completion, and leave `task_status` loops, `sleep`, and Monitor out of it. Collect every reviewer's final report before synthesis.

When a launch is rejected or a reviewer fails (quota, auth, timeout), report the failed axis and model under Verification. Relaunch the reviewer once on the same target. If it fails again, leave that axis-model pair unreviewed rather than moving it to another provider. When the other model covered the same axis, synthesis can still proceed.
