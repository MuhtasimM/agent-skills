# Security review checklist

Use this checklist for the security axis. Start with the changed trust boundaries and assets. Do not turn every unchecked item into a finding. Report a defect only when the diff creates or worsens a plausible attack path.

## Threat model

- Map affected entry points and trust boundaries. Include requests, uploads, webhooks, third-party APIs, configuration, model output, and background jobs when relevant.
- Name the assets at risk, such as credentials, personal data, payments, tenant data, admin actions, and availability.
- Test realistic abuse cases for spoofing, tampering, repudiation, information disclosure, denial of service, and privilege escalation.
- State the attacker capability, path, affected asset, and missing control for each blocking finding.

## Secrets and data exposure

- Check the diff, fixtures, logs, generated files, configuration defaults, and example environment files for live credentials or private data.
- Confirm ignore rules cover local secret files and private keys when the change adds such files.
- Exclude password hashes, reset tokens, full payment data, private keys, internal stack traces, SQL text, and other sensitive fields from responses and logs.
- Require transport encryption for sensitive external communication. Check encryption at rest only when the changed code owns that responsibility or a policy requires it.
- Redact secret values in the review report.

## Authentication and sessions

- Use a password hashing function intended for passwords with a project-approved cost. Never accept reversible encryption or a general-purpose fast hash.
- Check session cookie flags, expiry, rotation, revocation, fixation resistance, and CSRF defenses.
- Check login throttling and abuse controls where the change affects authentication.
- Make password reset and verification tokens short-lived, single-use, unpredictable, and invalidated after use.
- Validate signed tokens fully, including signature, expiry, intended issuer and audience, and allowed algorithm.

## Authorization and tenancy

- Require authentication on every protected entry point.
- Enforce authorization on the server for each action and resource. UI hiding is not an access control.
- Check ownership and tenant constraints on both reads and writes to prevent insecure direct object references and cross-tenant access.
- Scope admin routes, service credentials, API keys, and agent tools to the minimum permissions needed.
- Recheck authorization after redirects, asynchronous handoffs, retries, and background processing when identity context crosses a boundary.

## Untrusted input and output

- Validate type, structure, length, range, and allowed values at system boundaries. Prefer allowlists when the valid set is known.
- Parameterize database queries and separate shell arguments from command text.
- Encode output for its destination. Cover HTML, attributes, JavaScript, CSS, URLs, headers, logs, and templates as applicable.
- Restrict uploads by size and expected type. Verify content rather than trusting the filename or client MIME type. Store files outside executable paths.
- Validate redirect targets. For server-side fetches, restrict schemes and destinations, block private or reserved networks, and account for DNS rebinding and redirects.
- Treat deserialized objects, webhook payloads, third-party responses, and configuration files as untrusted.

## Browser and API configuration

- Check Content Security Policy, HSTS, content-type sniffing protection, framing policy, referrer policy, and permissions policy when the change owns HTTP headers.
- Keep credentialed CORS origins explicit. Reject wildcard origins with credentials and validate preflight behavior.
- Check CSRF protections on state-changing cookie-authenticated requests.
- Avoid exposing internal errors, implementation details, or sensitive identifiers in production responses.

## Dependencies and supply chain

- Locate the installation boundary. Confirm the workspace root, package-manager declaration, authoritative lockfile, and CI install command agree. Competing lockfiles or manager signals require investigation.
- Inspect manifest and lockfile changes, the direct package, meaningful transitive additions, maintainer and source trust, provenance, release history, license, and typosquatting risk.
- Use the pinned package manager's frozen or immutable install and audit workflow. Verify current commands in official documentation before relying on them.
- Never discover lifecycle scripts by running an ordinary install with unknown defaults. Bootstrap with scripts disabled or a verified fail-closed policy, inspect exact scripts and versions, then approve the narrowest required set.
- Do not run forced audit remediation automatically. Review the remediation diff, changelog, and reachability of advisories.
- Treat a clean advisory scan as partial evidence. It does not rule out a new malicious package or compromised release.

## LLM and agent features

- Treat model output, retrieved documents, tool results, and user prompts as untrusted data.
- Enforce permissions, tenant boundaries, and confirmation rules in code. A system prompt is not a security boundary.
- Keep secrets, unrelated tenant data, and unnecessary internal instructions out of model context.
- Validate and encode model output before it reaches SQL, a shell, dynamic code execution, HTML, URLs, or file paths.
- Scope tool permissions and require confirmation for destructive or irreversible actions.
- Bound token use, request rate, recursion, tool loops, and retrieved context size.
- Partition retrieval data by tenant and validate documents before indexing.

Adapted from [Addy Osmani's security checklist](https://github.com/addyosmani/agent-skills/blob/main/references/security-checklist.md).
