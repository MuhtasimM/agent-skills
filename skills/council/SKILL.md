---
name: council
description: Trigger this if the user says 'council'.
---

# Council

Bring in a council of delegates to help with the user's request, usually for review or feedback. Each member is one strong model from a subscription the user has, at high reasoning effort. If the user names council members, use those.

## Seat the council

In T3 Code, call `orchestrator_capabilities` once and seat one member per available subscription:

| Subscription | Usable when a provider has | Member target |
| --- | --- | --- |
| Claude | `driverKind: "claudeAgent"` and model `claude-opus-5-5` | `model: "claude-opus-5-5"`, `options: {effort: "high"}` |
| Codex | `driverKind: "codex"` and model `gpt-6.1-sol` | `model: "gpt-6.1-sol"`, `options: {reasoningEffort: "high"}` |

A provider is usable when `canRunChildTask` is `true` and no constraint marks it disabled. If a model is missing from the short list and `omittedModels` is above zero, call `orchestrator_capabilities` with `search` set to the model id before calling it unavailable. With several qualifying Claude instances, use `inheritedProviderInstanceId` when it is one of them, otherwise the first in the list.

Only the `codex` driver counts as the Codex subscription. Other providers that list a GPT model bill a different account, so they never fill a seat.

Outside T3 Code, use the harness's subagent tools and seat whichever of the two models the harness can reach at high effort.

The council needs at least two members. If only one subscription is reachable, or a member the user named is unavailable, report which one and stop instead of substituting.

## Run a round

Start every member with `delegate_task` in parallel: `mode: "async"`, `isolation: "shared"`, the member's `providerInstanceId`, `model`, and `options`, and `role: "review"` for review or feedback. Follow the `next` field of each result to wait.

A member starts with no parent history, so its `task` carries everything: the request, the absolute repository path, the exact commands that reproduce the diff or files in scope, and relevant context. For review or feedback, tell members to stay read-only and start no subagents.

Collect every response, then summarize the useful findings, disagreements, and recommended next steps.

For a code review, ask each member for a score out of 10. Each full review pass is one round. A fresh review after fixes starts a new round with a new `delegate_task` per member, whose brief includes the previous findings, what you changed, and any recommendation you rejected with the reason.

## Iterate

If you agree with the recommendations, make the changes and request a fresh review. Continue until every member is satisfied with the outcome. After round 3, stop and ask the user whether to continue.

Keep scope fixed to the original request. A recommendation that grows the scope goes in the summary as a follow-up, not into the change.

## Report

If the work ends in a pull request, put the results in the PR description, before the model and harness line at the end:

```markdown
## Council review

Rounds: 2

| Member | Round 1 | Round 2 |
| --- | --- | --- |
| Claude Opus 5.5 | 7/10 | 9/10 |
| GPT-6.1 Sol | 8/10 | 10/10 |
```

Write `no score` when a member gives none. If the PR is open, edit the description rather than posting a comment. If there is no PR, put the same results in the final reply only.

Adapted from [Theo Browne's council skill](https://github.com/t3dotgg/tstack/blob/main/skills/council/SKILL.md) (MIT).
