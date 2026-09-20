---
name: multi-code-review
description: Review a code change before merge with five independent specialist agents covering correctness, readability and simplicity, architecture, security, and performance. Use for pull requests, completed implementations, refactors, bug fixes, dependency changes, or human-authored and agent-authored diffs. Do not trigger for casual code explanation or when the user only asks to implement a change.
---

# Multi-code review

Review the proposed change, not the author. Approve code that improves the codebase and meets the task, even when another reasonable implementation exists. Do not rubber-stamp, invent defects, or block on personal taste.

This skill coordinates review only. Do not edit code, post comments, merge, or perform other external mutations unless the user separately asks for them.

## Prepare the review packet

1. Read the repository instructions and determine the review target. Prefer the user-specified diff, commit range, branch, or pull request. If none is given, inspect the working-tree and staged diff.
2. Collect the task or specification, changed files, relevant surrounding code, tests, and any verification already reported.
3. Read these references completely:
   - [references/review-axes.md](references/review-axes.md)
   - [references/security-checklist.md](references/security-checklist.md)
   - [references/performance-checklist.md](references/performance-checklist.md)
4. Build one shared packet for all reviewers. Include:
   - the review target and base
   - the intended behavior or task
   - repository instructions and conventions
   - changed-file list and diff access instructions
   - relevant test and build status
   - the required finding format below

Do not paste a large diff into every prompt when agents share the filesystem. Give exact commands or paths that reproduce the same review scope.

## Spawn five specialist agents

Spawn exactly five sub-agents, one for each axis:

1. `correctness-reviewer`
2. `readability-reviewer`
3. `architecture-reviewer`
4. `security-reviewer`
5. `performance-reviewer`

Start them independently with the same review packet and the axis-specific instructions from the reference. Tell the security reviewer to read `references/security-checklist.md` and the performance reviewer to read `references/performance-checklist.md`. Tell each agent to inspect only its assigned axis, remain read-only, and report only actionable findings supported by the diff or repository evidence.

Spawn all five even when one axis seems unlikely to produce findings. If the runtime cannot run five reviewers at once, preserve five distinct agents and launch the remaining agents as slots become available. Never combine two axes into one agent to fit a concurrency limit.

Each agent must return:

```markdown
## Findings

- [SEVERITY] `path/to/file.ext:line` Short title
  - Issue: What is wrong in the changed code.
  - Impact: The concrete failure, risk, or maintenance cost.
  - Fix: The smallest sound remedy.
  - Evidence: The code path, test, command output, or invariant supporting the claim.
  - Confidence: high | medium | low

## Checks performed

- Files and code paths inspected
- Commands or tests run, with results

## No-findings note

State what was checked when there are no findings.
```

Allowed severities are:

- `CRITICAL`: exploitable vulnerability, data loss, broken core behavior, or another release blocker.
- `REQUIRED`: a reproducible bug, unmet requirement, unsafe design regression, or material operational problem that must be fixed before merge.
- `OPTIONAL`: a concrete improvement worth considering that does not block merge.
- `NIT`: a minor convention or presentation issue. Use sparingly.

Do not accept vague concerns, speculative failures without a plausible path, or comments that only restate the diff. A finding needs a location, impact, and remedy. Agents should return no findings rather than fill a quota.

## Synthesize the independent reviews

Wait for all five agents. Then verify their claims against the code before including them.

1. Remove duplicates. Keep the clearest location and strongest evidence, and mention affected axes when useful.
2. Resolve disagreements with repository evidence, tests, specifications, and project conventions. Do not decide by vote.
3. Reclassify severity when the claimed impact does not match the definitions.
4. Separate pre-existing problems from regressions introduced by the reviewed change. Report pre-existing issues as non-blocking context unless the change makes them worse.
5. Identify unverified areas. Missing evidence is not proof that the change is safe.
6. Put correctness and security findings first, followed by architecture, performance, readability, and nits. Within each group, order by severity.

## Deliver the review

Lead with findings. Do not open with a summary.

```markdown
## Findings

[Deduplicated findings in priority order, each with severity, file:line, impact, evidence, and a concrete fix.]

## Verdict

Approve | Request changes | Unable to verify

[One short reason tied to the findings and verification status.]

## Axis summary

- Correctness: ...
- Readability and simplicity: ...
- Architecture: ...
- Security: ...
- Performance: ...

## Verification

- Checks completed and their results
- Checks not completed and why
```

Use `Request changes` when any verified `CRITICAL` or `REQUIRED` finding remains. Use `Unable to verify` when missing context or failed verification prevents a defensible merge decision. Otherwise use `Approve`, even if optional comments or nits remain.

For changed behavior, check for a regression test. For UI changes, check relevant visual evidence when available. For dependency changes, inspect the manifest and lockfile, release or migration notes when available, test coverage around the dependency, license compatibility, and known security risk. Do not browse for current dependency facts unless the review scope permits internet research.

Adapted from [Addy Osmani's code-review-and-quality skill](https://github.com/addyosmani/agent-skills/blob/main/skills/code-review-and-quality/SKILL.md).
