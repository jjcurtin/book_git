# Project Handoff — Intro to Git & GitHub lecture

This file captures the goal, decisions, repo state, and next steps so a new chat can pick up with full context.

## What we are building

A teaching resource on using Git and GitHub for students in a UW–Madison **masters in data science** program. It has two outputs produced from the **same `.qmd` source files**:

1. A **web book** published to GitHub Pages (`gh-pages`).
2. A **revealjs slide deck** (one deck per unit) published to **Posit Connect Cloud**.

The materials are based on a seven-video Software Carpentry "Git novice" series from UW. The full transcripts are in `youtube/v1.md` … `youtube/v7.md` (plus `youtube/youtube.md` with the playlist + setup links). Read those for source content.

### The live lecture (the near-term priority)

- **One ~60-minute, interactive lecture.** Students follow along on their own laptops.
- **Prerequisites assumed done:** Git installed, GitHub account created. So setup (config, SSH keys) is only a quick verification in the lecture, not a full walk-through.
- **One running example, built up slowly across the whole hour.** It must be *different* from the videos' Vlad Dracula / planets story.
- Because an interactive hour is slow, we **deliberately cut content**. Branches and conflicts are **not** covered live — they remain in the book/decks as reference-only units.

### The running example: Bucky's game-day menu

- Theme: **Bucky Badger planning a game-day (tailgate) menu** at UW–Madison. A bit funny, Wisconsin-flavored (brats, cheese curds, Babcock ice cream, etc.).
- **Multiple files** (decided), e.g. `brats.txt`, `cheese_curds.txt`, `desserts.txt`, so we can demonstrate staging multiple files in one commit and motivate *why* `add` is a separate step from `commit`.
- Suggested repo name: `gameday-menu`.
- `.gitignore` demo idea: ignore throwaway files like `*.tmp` and a `receipts/` folder.
- GitHub step: push `gameday-menu` to the student's own account.

## Content prioritization

| Unit | Title | In the live hour? | Source video |
|------|-------|-------------------|--------------|
| 1 | Introduction and Setup | Yes — brief (concept + config check) | v1 |
| 2 | Tracking Changes | Yes — **core** (`add`/`commit` staging model, `status`, `log`, `diff`) | v2 |
| 3 | Exploring History | Yes — **quick** (`checkout` to restore a file) | v3 |
| 4 | Ignoring Files | Yes (`.gitignore`) | v4 |
| 5 | Remotes in GitHub | Yes (create repo, `remote add`, `push`; mention `pull`/`clone`) | v7 |
| 6 | Branches | Reference only (not in hour) | v5 |
| 7 | Conflicts | Reference only (not in hour) | v6 |

Rough time budget for the hour: motivation (5) → config check (3) → init/status (7) → add/commit/log/diff done twice so it sticks (20) → `.gitignore` (6) → GitHub remote + push (14) → wrap + cheatsheet + what's next (5).

Note: the **book** can still fully cover branches/conflicts; only the **lecture** drops them.

## How publishing works (the dual-output mechanism)

There is **no committed `_quarto.yml`**. `publish.sh` swaps one in per target, publishes, then deletes it:

- `./publish.sh book` → copies `_quarto_book.yml` → `_quarto.yml`, runs `quarto publish gh-pages --no-browser`, cleans up.
- `./publish.sh slides <file.qmd>` → copies `_quarto_slides.yml` → `_quarto.yml`, runs `quarto publish posit-connect-cloud <file> --no-browser`, cleans up.
- `./publish.sh slides_wide <file.qmd>` → copies `_quarto_slides_wide.yml` → `_quarto.yml`, runs `quarto publish posit-connect-cloudb <file> --no-browser`, cleans up.

So each `.qmd` must render correctly as **both** a book chapter (html, `book.css`) and a revealjs deck (`slides_teaching.css` / `slides_wide_teaching.css`). Author headings so they divide cleanly into slides: in revealjs a `#`/`##` starts a new slide; the first `#` of a chapter file becomes the title slide.

Open question (unresolved): whether `posit-connect-cloudb` on line 37 of `publish.sh` is intentional (a second provider alias) or a typo for `posit-connect-cloud`. Confirm with John.

## Repo state (as of this handoff)

Chapter files (stubs — each contains only a single `#` heading so far):

- `index.qmd`, `cheatsheet.qmd` — unnumbered front/back matter (use `## ... {.unnumbered}`).
- `01_setup.qmd` — Introduction and Setup
- `02_tracking_changes.qmd` — Tracking Changes
- `03_exploring_history.qmd` — Exploring History
- `04_ignoring_files.qmd` — Ignoring Files
- `05_remotes_github.qmd` — Remotes in GitHub
- `06_branches.qmd` — Branches (reference only)
- `07_conflicts.qmd` — Conflicts (reference only)

`_quarto_book.yml` references all of the above in the `chapters:` list in this order.

**None of the chapter stubs have content yet** beyond their title heading.

### Config / CSS files

- `_quarto_book.yml` — book config. Title "Introduction to Git and Github". (John fixed the earlier title-quote and `book_git` URL typos.)
- `_quarto_slides.yml` — standard revealjs config, `css: slides_teaching.css`, references `bibliography: refs.bib`.
- `_quarto_slides_wide.yml` — wide revealjs config, now correctly `css: slides_wide_teaching.css` (was `slides_wide.css`), references `bibliography: refs.bib`.
- `_publish.yml` — **deleted** by John. It will be regenerated on the first publish of each target. First publish of each file will prompt to confirm creating a new deployment.
- `book.css`, `slides_teaching.css`, `slides_wide_teaching.css` — all three now contain a shared utility-class vocabulary ported from `~/github/slide_decks/presentation.css`.

### Known loose ends

- `refs.bib` is referenced by both slide configs but **does not exist yet** — create it (even empty) before publishing slides, or remove the bibliography line.
- Confirm `posit-connect-cloudb` vs `posit-connect-cloud` in `publish.sh` (see above).

## Formatting conventions (John's style)

Modeled on `~/github/slide_decks/archive/2026/power/power.qmd` with theme `~/github/slide_decks/_quarto_uw.yml` + `~/github/slide_decks/presentation.css`. Key patterns:

- **One slide per `##`**, slides separated by a long `---` horizontal rule.
- **Progressive builds by slide duplication, not reveal fragments** — repeat a slide and change which part is highlighted. Degrades gracefully to the book.
- **UW red `#c5050c`** is the single accent. Emphasize key terms/commands inline with `[term]{.uwred}`.
- **Gap spacers** `<div class="gap-xs|sm|md|lg"></div>` instead of `<br>` for vertical rhythm.
- **Hand-written `<table>` + `.hl` / `.hlbox`** classes to highlight a row (`<tr class="hl">`), a column (`class="hl"` on each cell), or outline (`hlbox`) — used for the highlight-to-teach build.
- **Rhetorical callouts**: wrap in `::: {.callout-wide}` around `::: {.callout-important}` titled `# Question` to pose a question to the room (good for the interactive "your turn" beats).
- **Code**: `echo: true`; build incrementally (show, then run on small input, then extend). Git commands are shell, not R — decide whether to show them as non-executed ` ```bash ` blocks or executed `{bash}` cells (git side effects make non-executed blocks safer for reproducibility; TBD).

### Utility classes ported into all three CSS files

Added `.gap-xs/sm/md/lg`, `.callout-wide`, and `.hl`/`.hlbox` table-highlight classes to `book.css`, `slides_teaching.css`, and `slides_wide_teaching.css`. `book.css` also gained `.smaller`, `.medium`, `.centered`, `.gray` for parity. Color classes (`.uwred`, `.red`, etc.) and honeydew code-output styling already existed in all three.

**Two deliberate deviations from `presentation.css`** (confirm with John if he wants exact parity):
1. Did **not** port the base `.callout` absolute-positioning rule (the 300px bottom-left box), so callouts render normally full-width by default and `.callout-wide` is a safe wrapper matching his authoring habit.
2. Did **not** port the callout 75% font-size reduction.

## Next steps (start here tomorrow)

1. Draft **Unit 1 (`01_setup.qmd`)** content using the conventions above and the Bucky game-day menu example. First real chapter + deck.
2. Decide the git-command code-block approach (non-executed `bash` vs executed `{bash}`).
3. Create `refs.bib` (or drop the bibliography line from the slide configs).
4. Confirm the `posit-connect-cloudb` question in `publish.sh`.
5. Optionally render the book to confirm structure builds, then continue through Units 2–5 (live-hour content), then 6–7 (reference).
