# Performance review checklist

Use this checklist for the performance axis. Focus on work introduced by the diff and on execution paths that matter. A rule of thumb is not a blocking finding without a realistic workload, measurement, or clear complexity argument.

## Establish evidence

- Identify the affected path, expected load, input size, device class, and project performance budget or service objective.
- Prefer production field data, existing benchmarks, query plans, traces, profiles, bundle reports, and request metrics.
- Compare before and after under the same conditions. Report commands, data sets, throttling, warm-up, sample count, and uncertainty.
- Use existing project tools first. Do not install or execute an unpinned measurement package without authorization.
- Verify current public thresholds against an authoritative source when they affect the verdict. Common web targets are LCP at or below 2.5 seconds, INP at or below 200 milliseconds, and CLS at or below 0.1 at the 75th percentile.

## Algorithm and resource bounds

- Check time and space growth with realistic maximum input sizes.
- Bound loops, result sets, queues, retries, recursion, concurrency, caches, uploads, and in-memory buffering.
- Look for repeated parsing, copying, serialization, allocation, and work inside hot loops.
- Check cleanup of timers, listeners, subscriptions, file handles, database connections, streams, object URLs, workers, and retained references.
- Check backpressure and cancellation across streams, queues, network calls, and background work.

## Database and storage

- Find N+1 queries and per-item writes. Prefer joins, eager loading, batching, or bulk operations when semantics allow.
- Check indexes for new filter, join, sort, and uniqueness patterns. Use a query plan for material claims.
- Paginate or stream collections that can grow. Avoid fetching unused columns or entire tables.
- Check transaction scope, lock duration, connection-pool use, contention, and repeated round trips.
- Validate cache keys, invalidation, cardinality, expiry, stampede control, and memory limits. A fast stale answer can still be a correctness bug.

## Backend and API paths

- Keep heavy synchronous computation and blocking I/O out of latency-sensitive handlers.
- Check duplicate downstream requests, serial calls that can safely run concurrently, missing batching, and retry amplification.
- Review response size, compression, serialization cost, streaming, and caching headers.
- Check timeouts, concurrency limits, queue depth, and graceful load shedding for remote calls.
- Treat fixed latency targets as project-specific. Use the project's percentile objective and expected traffic rather than a universal number.

## JavaScript and interaction responsiveness

- Check initial and route-level bundle growth. Confirm code splitting and tree shaking with a bundle report rather than source inspection alone.
- Find long main-thread tasks, large hydration work, repeated parsing, and non-critical work inside event handlers.
- Split or yield long work only when profiling shows it blocks interaction. Consider a worker for CPU-heavy independent work.
- Avoid memoization by reflex. Confirm that repeated renders or calculations are costly enough to justify cache overhead and dependency complexity.
- Defer third-party scripts when possible and account for their transfer, parse, execution, privacy, and main-thread cost.

## Rendering, CSS, and lists

- Find unnecessary component or full-page renders and unstable props or selectors that fan out updates.
- Check forced synchronous layout caused by interleaved DOM reads and writes.
- Prefer compositor-friendly animation properties when the changed animation causes layout or paint work.
- Virtualize long lists when DOM size and interaction measurements justify it.
- Check off-screen rendering work, retained detached nodes, and listeners or observers that survive unmount.
- Preserve back-forward cache eligibility unless the application has a measured reason not to.

## Images, fonts, and network

- Serve appropriately sized responsive images. Use efficient formats supported by the product and include dimensions to prevent layout shift.
- Lazy-load below-the-fold media. Do not lazy-load the likely largest contentful paint image, and prioritize only genuinely critical resources.
- Check font count, weights, subsets, preload use, display behavior, and fallback metrics against actual page needs.
- Cache content-addressed static assets for a long duration. Give dynamic responses explicit cache rules where safe.
- Avoid render-blocking non-critical CSS and JavaScript, unnecessary redirects, duplicate fetches, and needless connection setup.
- Diagnose slow time to first byte by separating DNS, connection and TLS, server work, and content transfer.

## Infrastructure

- Check whether the change alters CDN use, cacheability, region placement, horizontal scaling, health checks, or load-balancer behavior.
- Look for single-process state, unbounded local caches, sticky assumptions, and jobs that duplicate across replicas.
- Confirm observability can detect the claimed risk with latency percentiles, error rate, saturation, queue depth, memory, or other relevant signals.

## Reporting standard

Quantify material findings when possible. Good evidence includes query count growth, asymptotic cost, bytes added to a critical bundle, retained memory, extra network round trips, trace duration, or a reproducible before-and-after benchmark. State assumptions. Never invent measurements.

Adapted from [Addy Osmani's performance checklist](https://github.com/addyosmani/agent-skills/blob/main/references/performance-checklist.md).
