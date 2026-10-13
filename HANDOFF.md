# Project Handoff — Intro to Git & GitHub lecture

This file captures the goal, decisions, current state, and open items so a new chat can pick up with full context.

## What we are building

A teaching resource on using Git and GitHub for students in a UW–Madison **masters in data science** program. Two outputs are produced from the **same `.qmd` source files**:

1. A **web book** published to GitHub Pages (`gh-pages`).
2. A **revealjs slide deck per unit**, published to **Posit Connect Cloud**.

Based on a seven-video Software Carpentry "Git novice" series from UW. Transcripts are in `youtube/v1.md` … `youtube/v7.md` (plus `youtube/youtube.md` with playlist + setup links).

### The live lecture

- **One ~60-minute, interactive lecture.** Students follow along on their own laptops.
- **Prerequisites assumed done before class:** Git installed, GitHub account, SSH key set up. Covered by appendices, not live lecture time.
- **One running example built up slowly across the hour** (see below), deliberately *not* the videos' Vlad Dracula / planets story.
- **Units 1–5 are taught live; Units 6–8 are reference-only** (explored on their own afterward).

### The running example: Bucky's game-day menu

- **Bucky Badger planning a game-day tailgate menu** at UW–Madison. Wisconsin-flavored and a bit funny.
- Repo: `gameday-menu`. Files: `brats.txt`, `cheese_curds.txt`, `desserts.txt` (multiple files, so we can stage several in one commit and motivate why `add` is separate from `commit`).
- `.gitignore` demo: `*.tmp` scratch files and a `receipts/` folder of photos.
- GitHub step: push `gameday-menu` to the student's own account.
- Conflicts unit: a second clone, `gameday-menu-sam`, stands in for a collaborator ("Sam").
- Branches unit: a `veggie-option` branch.

## Status: the project is largely built

Units 1–6 and 8 are **fully written and published as decks**; Unit 7 (Stash) is newly written and **not yet published** as a deck. Four appendices exist. This is well past a draft — remaining work is review/polish and any new additions.

### Units (each is a book chapter *and* a standalone deck)

| # | File | Title | Live? | Notes |
|---|------|-------|-------|-------|
| 1 | `01_setup.qmd` | Introduction and Setup | Yes | motivation, `git config`, `init`, `status` |
| 2 | `02_tracking_changes.qmd` | Tracking Changes | Yes (core) | add/commit staging model, `diff`, `log`; highlight-table builds |
| 3 | `03_exploring_history.qmd` | Exploring History | Yes | uses modern `git restore` |
| 4 | `04_ignoring_files.qmd` | Ignoring Files | Yes | `.gitignore` |
| 5 | `05_remotes_github.qmd` | Remotes in GitHub | Yes | SSH verify, `remote add`, `push`, pull/clone |
| 6 | `06_conflicts.qmd` | Conflicts | Reference | two-clone "Sam" scenario via `git pull` |
| 7 | `07_stash.qmd` | Stashing Changes | Reference | pull-failure motivation (reuses Sam setup); `stash`/`pop`/`list` |
| 8 | `08_branches.qmd` | Branches | Reference | modern `git switch -c`, `merge`, cleanup; closes with stash-to-switch |

**Note the order:** Conflicts (6) precedes Stash (7) precedes Branches (8). Stash builds directly on the Conflicts pull workflow (a blocked `git pull` from uncommitted local edits), and Branches closes by showing stash in the branch-switching context. Internally consistent and intentional (differs from the original video order and from earlier versions of this handoff).

**Modernized commands:** we use `git restore` (not `git checkout` for restoring files) and `git switch` (not `git checkout` for branches). This is documented in `index.qmd`.

### Front/back matter and appendices

- `index.qmd` — book landing page; includes a table of links to all seven published decks.
- `install_git_windows.qmd` — Appendix: installing Git for Windows / Git Bash (`#sec-git-windows`).
- `ssh_setup.qmd` — Appendix: generating SSH keys and adding them to GitHub (`#sec-ssh-setup`).
- `meld_difftool.qmd` — Appendix: installing Meld and configuring it as Git's default `difftool` (`#sec-meld-difftool`). Cross-platform (Win/mac/Linux); includes an optional `mergetool` section. Based on John's ARC docs.
- `cheatsheet.qmd` — back-matter quick reference of every command (`#sec-cheatsheet`).

In `_quarto_book.yml`, the eight units are `chapters:` and the four files above are `appendices:` (order: install_git_windows, ssh_setup, meld_difftool, cheatsheet).

A footer pointer to the Meld appendix sits on the `git diff` slide in `02_tracking_changes.qmd` (where diff is first introduced).

## How publishing works (dual-output mechanism)

There is **no committed `_quarto.yml`**. `publish.sh FORMAT [FILE]` swaps one in per target, publishes, then cleans up:

- `./publish.sh book` → copies `_quarto_book.yml` → `_quarto.yml`, `quarto publish gh-pages --no-browser`, removes `_quarto.yml` and `_book`.
- `./publish.sh slides <file.qmd>` → copies `_quarto_slides.yml` → `_quarto.yml`, `quarto publish posit-connect-cloud <file> --no-browser`, removes `_quarto.yml`, `*_files`, `*.html`.
- `./publish.sh slides_wide <file.qmd>` → same as `slides` but with `_quarto_slides_wide.yml`.

So every `.qmd` must render correctly as **both** a book chapter (`book.css`) and a revealjs deck (`slides_teaching.css` / `slides_wide_teaching.css`). Standalone decks do **not** have access to other files, so **avoid `@sec-` cross-references between units/appendices** — they resolve in the book but break in a standalone deck. Use plain-text pointers (e.g., the Meld footer) instead.

`_publish.yml` is present and holds the real Posit Connect Cloud IDs/URLs for the published decks (regenerated by publishing; do not hand-edit). **Stale mapping to watch:** when Unit 7 (Stash) was inserted, `07_branches.qmd` was renamed to `08_branches.qmd` but `_publish.yml` was deliberately left untouched — so its Branches entry still has `source: 07_branches.qmd`. Republishing the Branches deck as `08_branches.qmd` will create a *new* deck unless that `source:` key is first updated to `08_branches.qmd` (preserving its id/url). Unit 7 (Stash) has no deck yet; `./publish.sh slides 07_stash.qmd` creates it.

## Authoring conventions (John's style)

Modeled on `~/github/slide_decks/archive/2026/power/power.qmd` (theme `~/github/slide_decks/_quarto_uw.yml` + `presentation.css`).

- **Units** are slide-formatted: one slide per `##`, slides separated by a long `---` rule, first `#` is the chapter/title slide. **Appendices** are book-prose (no `---` separators), with `#sec-` labels and `.callout-note`.
- **Progressive builds by slide duplication, not reveal fragments** — repeat a slide and change what's highlighted (`[term]{.uwred}` or `.hl` table classes). Degrades gracefully to the book.
- **UW red `#c5050c`** is the single accent; emphasize key terms/commands inline with `[term]{.uwred}`.
- **Gap spacers** `<div class="gap-xs|sm|md|lg"></div>` for vertical rhythm.
- **Hand-written `<table>` + `.hl`/`.hlbox`** for highlight-to-teach builds.
- **Interactive beats:** `::: {.callout-wide}` wrapping `::: {.callout-important}` titled `# Your turn` / `# Next up` / `# Try it`.
- **Footers:** `::: {.footer} ... :::` for asides and links.
- **Git commands are shown as non-executed ` ```bash ` blocks with simulated output** pasted below them (not executed `{bash}` cells) — git side effects make this reproducible and safe. Diff output uses hand-colored `<pre>`/`<span>` for green/red.

### CSS

`book.css`, `slides_teaching.css`, `slides_wide_teaching.css` all carry a shared utility vocabulary ported from `presentation.css`: `.gap-*`, `.callout-wide`, `.hl`/`.hlbox`, plus the color classes (`.uwred`, etc.) and honeydew code-output styling. Two deliberate deviations from `presentation.css`: did not port the base `.callout` absolute-positioning box, and did not port the callout 75% font shrink.

## Open items / loose ends

- **Resolved since earlier handoffs:** the `01_setup.qmd` "two vs. three" wording and "idenity" typo are fixed; the `posit-connect-cloudb` typo in `publish.sh` is fixed (both slide targets use `posit-connect-cloud`); `refs.bib` is no longer referenced by either slide config (bibliography lines removed), so no bib file is needed.

## Possible next steps

- Decide whether to add a Meld footer at any other `diff`/`difftool` touchpoints (currently only Unit 2).
- Candidate additional appendices discussed but not built: using Git inside RStudio (Git pane/Projects); pull requests & collaboration on GitHub; undoing mistakes in depth (`reset`/`revert`/`amend`; note `stash` now has its own Unit 7); a starter data-science `.gitignore`.
- Optionally render the book (`./publish.sh book`) to confirm everything still builds after edits.
