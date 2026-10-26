---
name: pr
description: "Use when writing or updating a PR title or body, including when opening a pull request."
metadata:
  credits:
    skill: pr
    author: Matt Pocock
    url: "https://github.com/mattpocock/skills/blob/main/skills/engineering/pr/SKILL.md"
---

Write for a reviewer who has not seen the work and for someone searching history a year from now. The diff already shows _what_ changed. The description carries what the diff cannot: why, how to read it, what proves it works, and what could go wrong.

## Gather context

1. Find the base branch (`gh pr view --json baseRefName` for an existing PR, else `gh repo view --json defaultBranchRef`) and fetch it.
2. Read every commit on the branch (`git log <base>..HEAD`) and the full diff (`git diff <base>...HEAD`), not just the latest commit.
3. Read linked issues, the task, and any verification already run in this session.
4. Look for a repo PR template (`.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE/`, `docs/`). When one exists, its headings, HTML comments and checkboxes win: fit the sections below inside it and tick only boxes that are true.
5. Check recent merged PR titles (`gh pr list --state merged --limit 10`) for the repo's title convention.

If the diff mixes a refactor with a behavior change, or runs past roughly 1000 changed lines, tell the user and suggest a split before writing.

## Title

One short imperative line, under 70 characters, naming the actual change: `Cache unchanged saves in the editor`, not `Fix bug` or `Updates`. Follow the repo's convention (Conventional Commits prefix, `[area]` tag) when its history uses one. Leave off `(#123)`; GitHub adds it on squash.

## Body

Use this template:

```markdown
## Summary

<one or two sentences: the problem and why this approach>

<diagram, diff-sketch, or tree>

## Evidence

- **Before:** <screenshot/output/failing test run>
  **After:** <screenshot/output/passing test run>

## Merge Danger

**Door:** <one-way or two-way>

<optional: description>

**Blast Radius:** <one-word description>

<optional: potential ramifications of merge>
```

Open each section with its point and keep prose brief. Use the user's domain language from `GLOSSARY.md` when the repo has one. Describe only behavior that is in the diff.

### Summary

Start with the problem and why this approach, in one or two sentences, so the description makes sense without opening links. Then show the change with the smallest visual that makes it clear. Read [references/summary-visuals.md](references/summary-visuals.md) to pick the view: pseudocode, call tree, component tree, file tree, Mermaid, or a diff-sketch.

For a refactor, say outright that behavior is unchanged. For a PR touching many files, add a line telling the reviewer where to start.

### Evidence

Concrete evidence that the change works. Show a before and after.

Screenshots are S-tier - when the environment is set up for it and the change is visual. For any change a user can see, capture before and after screenshots and upload them with the PR: read [references/screenshots.md](references/screenshots.md) for capture, layout, and `gh --attach`.

Execution-based evidence is A-tier. Test results, console output. Show the exact test that now fails and passes, using pseudocode.

List the commands you ran. Claim a check passed only when you ran it or have its output. Name what you could not verify (a device, a production-only path, a check CI covers but you skipped).

### Merge Danger

Describe whether it's a one-way or two-way door. You can walk back through two-way doors, but not one-way doors. A PR that is cheap to roll back is lower risk. Changes that involve destructive actions or hard-to-reverse decisions are one-way doors: data migrations, deletions, published APIs, sent messages.

The blast radius is the potential impact or scope of the changes introduced by this PR. Consider all possibilities. Examples are layout shift, breakages for consumers, mobile responsiveness, etc. Call out changes to dependencies, auth, permissions, CI workflows, or user data by name. When users or operators must act after merge, say what they must do.

### Links

Put issue links after Merge Danger. Use `Closes #N` only when the PR fully resolves the issue, and `Part of #N` otherwise.

## Submit

Pass the body with `gh pr create --body-file` or a quoted heredoc so backticks and `$` survive. With screenshots, use `--body-file` plus `--attach` as described in [references/screenshots.md](references/screenshots.md). Keep any attribution line the environment requires as the last line of the body.

When later pushes change what the PR does, update the body to match before asking for another review.
