# Credits

- **Base skill:** [Matt Pocock's `pr`](https://github.com/mattpocock/skills/blob/main/skills/engineering/pr/SKILL.md) (MIT). The Summary / Evidence / Merge Danger template and section guidance come from it.
- **Summary visuals:** [Dex Horthy](https://github.com/dexhorthy)'s [`show-me`](https://github.com/humanlayer/skills/blob/main/plugins/show-me/skills/show-me/SKILL.md) skill (HumanLayer), via Matt's skill. `references/summary-visuals.md` reproduces its menu of views almost word for word. It is copied in rather than depended on so `pr` installs standalone.
- **Added rules** (gathering context, title, why-first summary, unverified checks, security call-outs, links, submitting) distilled from:
  - Google eng-practices, [Writing good CL descriptions](https://google.github.io/eng-practices/review/developer/cl-descriptions.html) and [Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html)
  - GitHub Docs, [Best practices for pull requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/getting-started/best-practices-for-pull-requests)
  - Claude Code's built-in PR instructions (read all commits against the base, short title, heredoc body)
  - [t3dotgg/tstack `file-pr`](https://github.com/t3dotgg/tstack/tree/main/skills/file-pr), [databricks-sdk-go `write-pr-description`](https://github.com/databricks/databricks-sdk-go/tree/main/.agent/skills/write-pr-description), [Yoast `create-pr`](https://github.com/Yoast/wordpress-seo/blob/trunk/docs/workflows/create-pr.md), [s3s `pull-request`](https://github.com/s3s-project/s3s/tree/main/.agents/skills/pull-request)
- **Screenshot uploads:** the idea of attaching before/after media with `gh --attach` comes from [vercel-labs/before-and-after](https://github.com/vercel-labs/before-and-after). Its text is not reused (PolyForm Shield license); `references/screenshots.md` is written from the `gh` help and the GitHub CLI's `internal/attachments` source.
