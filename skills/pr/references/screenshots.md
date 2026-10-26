# Screenshots for UI changes

Read this when the diff changes something a user sees: components, styles, templates, layouts, copy, or rendered output. Screenshots go in the Evidence section and are uploaded with `gh --attach`, which needs GitHub CLI 2.99 or later (`gh --version`).

## Capture

Use whatever browser tool the environment has: Playwright (`npx playwright screenshot --viewport-size=1280,800 <url> <file>`), agent-browser, a Chrome or browser MCP, or T3 Code's preview tools.

If Playwright reports that its browser executable doesn't exist, add `--channel=chrome` to use the installed Google Chrome instead of downloading one.

1. Make a working folder outside the repo, `/tmp/pr-<branch>/`. The body file and every capture go here, so nothing lands in the branch.
2. **After:** run the app from the PR branch and capture the changed screen.
3. **Before:** capture the same screen from the base branch. Check it out in a separate worktree (`git worktree add /tmp/pr-<branch>/base <base>`), run it on another port, capture, then `git worktree remove` it. For a brand-new screen there is no before; show the after alone.
4. Keep both captures comparable: same viewport, same data, same scroll position and UI state. Crop to the changed component when the page is long; when comparing full pages, make both images the same height so they line up side by side.
5. Add a 390px-wide pair when the layout is responsive. Record a short video (`.mp4`, `.mov`, `.webm`) or GIF when the change is an interaction or animation.
6. Look at every image before it goes up. Uploads are visible to anyone who can see the PR and cannot be undone, so use test accounts and sample data, and keep tokens, emails, and private URLs out of frame.

When the app cannot run (missing services, auth you don't have), say so under "Not verified" instead of mocking a screenshot.

## Write the body

Name files `before.png`, `after.png`, `before-mobile.png`, and so on, and reference each one by the same absolute path you will pass to `--attach`:

```markdown
## Evidence

| Before | After |
| --- | --- |
| ![Settings page before: save button below the fold](/tmp/pr-<branch>/before.png) | ![Settings page after: save button pinned to the footer](/tmp/pr-<branch>/after.png) |
```

Each row is one before/after pair at one width. Add a row for the mobile pair rather than a column: GitHub vertically centers the shorter image in a row, so mixing widths in one row leaves a large gap above the shorter one.

Alt text says what the image shows. Put a video on its own line (`![](/tmp/pr-<branch>/flow.mp4)`); GitHub renders it as a player.

## Upload

Pass the body file and every capture by path:

```bash
gh pr create --title "..." --body-file /tmp/pr-<branch>/body.md \
  --attach /tmp/pr-<branch>/before.png --attach /tmp/pr-<branch>/after.png
# or, for an existing PR
gh pr edit <number> --body-file /tmp/pr-<branch>/body.md \
  --attach /tmp/pr-<branch>/before.png --attach /tmp/pr-<branch>/after.png
```

`gh` uploads each file and rewrites the matching reference to a `github.com/user-attachments` URL. It matches by absolute path. A relative `./before.png` resolves against the body file's folder only from gh 2.103; on 2.99–2.102 it resolves against the working directory, misses, and the image is appended to the end of the body while the table keeps a broken local link. Absolute paths work on every version.

If some uploads fail, `gh` still creates or updates the PR with the ones that worked and exits non-zero. Re-run `gh pr edit` with only the failed files.

Then check the result: `gh pr view <number> --json body --jq .body` should show `user-attachments` URLs where the local paths were, and no `/tmp/` paths or images appended at the end. If a reference was missed, replace it with the appended URL by hand and `gh pr edit --body-file` without `--attach`, so nothing uploads twice.

With `gh` older than 2.99, tell the user and describe the visual change in words under Evidence; leave the images out of the branch.
