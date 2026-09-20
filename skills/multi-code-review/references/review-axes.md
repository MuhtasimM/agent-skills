# Review-axis instructions

The coordinator must give each reviewer the shared review packet plus only the section for that reviewer's axis. Review changed code in its surrounding context. Flag pre-existing issues only when the change depends on them or makes them worse.

## Correctness reviewer

Determine whether the change implements the stated behavior.

- Trace inputs, state transitions, outputs, and error paths through the changed code.
- Check boundary cases such as empty values, nullability, limits, ordering, retries, partial failure, concurrency, and cleanup.
- Read tests before judging the implementation. Confirm that assertions exercise behavior and would fail under a meaningful regression.
- Compare the implementation with the task, specification, API contract, and existing call sites.
- Look for off-by-one errors, stale state, race conditions, broken invariants, incompatible migrations, and failure paths that report success.
- Run the narrowest relevant tests when safe. Report commands and results. Do not claim that tests pass unless you ran them or received trustworthy output in the packet.

Stay out of style, broad design preferences, speculative security, and micro-optimization unless they directly cause incorrect behavior.

## Readability and simplicity reviewer

Judge whether a maintainer can understand and safely change the code.

- Check names, control flow, locality, comments, module organization, and consistency with nearby code.
- Flag deep nesting, tangled conditionals, clever constructs, ambiguous fallbacks, and abstractions that cost more than they explain.
- Look for repeated conditionals that suggest a missing explicit model or dispatcher.
- Identify dead or orphaned code made obsolete by the change. Report it, but do not delete it.
- Treat large files and diffs as inspection signals, not automatic failures. Explain the concrete comprehension or change-isolation problem.
- Prefer a remedy that removes branches or concepts over moving the same complexity behind another wrapper.

Do not report formatting already enforced by tooling, personal naming preferences, or requests for comments that merely narrate obvious code.

## Architecture reviewer

Judge how the change fits the system's existing design and ownership boundaries.

- Inspect dependencies, module boundaries, data flow, public interfaces, and ownership of feature-specific logic.
- Check whether dependencies flow in the intended direction and whether the change creates cycles or hidden coupling.
- Look for near-duplicates of canonical helpers, misplaced shared code, pass-through layers, and abstractions introduced before a stable repeated need exists.
- For refactors, count whether branches, modes, layers, or concepts actually disappear. Moving complexity is not simplification.
- Check type and schema boundaries. Flag casts, gratuitous optionality, silent fallback, or broad types that conceal an invariant.
- Propose a named structural remedy for every blocking structural finding, such as moving logic to its owning package, deleting a wrapper, making a boundary explicit, or collapsing duplicate flows.

Do not demand a new architecture merely because it is familiar. Existing project conventions win unless the change measurably harms code health.

## Security reviewer

Look for vulnerabilities introduced or exposed by the change. Treat all external data as untrusted until a boundary validates it.

Read [security-checklist.md](security-checklist.md) before reviewing. Apply only the sections relevant to the changed attack surface.

- Trace authentication, authorization, tenancy, and privilege checks on every affected entry point.
- Check injection risks across SQL, shell commands, templates, URLs, headers, logs, deserialization, and dynamic code execution.
- Check input validation and output encoding at system boundaries.
- Look for secrets in source, logs, fixtures, generated artifacts, and configuration defaults.
- Review cryptography, token handling, session state, CORS or CSRF behavior, file paths, redirects, upload handling, and sensitive error messages when relevant.
- For dependencies, inspect source trust, lockfile changes, known vulnerabilities when current data is available, and risky transitive additions.
- Describe a plausible attack path and affected asset. Do not label theoretical hardening advice as a vulnerability.

Never expose a live secret in the report. Identify its location and redact the value.

## Performance reviewer

Look for material regressions in latency, throughput, memory, I/O, network usage, rendering, and scale behavior.

Read [performance-checklist.md](performance-checklist.md) before reviewing. Apply only the sections relevant to the changed execution paths.

- Identify N+1 work, repeated parsing or allocation, redundant network requests, unnecessary renders, and synchronous blocking on hot paths.
- Check bounds on loops, queues, retries, caches, result sets, concurrency, and data fetching.
- Check pagination or streaming where collections can grow.
- Compare algorithmic cost and query count with realistic input sizes.
- Inspect resource cleanup, backpressure, caching correctness, and batch opportunities when relevant.
- Quantify impact with a benchmark, query count, allocation size, or defensible estimate when possible. State assumptions.
- Distinguish hot-path problems from negligible setup work. Do not block on micro-optimizations without evidence.

When measurement is feasible and safe, recommend or run the narrowest useful benchmark. Never invent numbers.
