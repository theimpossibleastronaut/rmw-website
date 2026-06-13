# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

The source for the rmw website (https://theimpossibleastronaut.github.io/rmw-website/), a static Jekyll site published from the root of the `trunk` branch via GitHub Pages. The rmw source code itself lives at https://github.com/theimpossibleastronaut/rmw — code changes belong there, not here.

## Commands

- Preview locally: `bundle exec jekyll serve` then browse http://localhost:4000/
- Build only: `bundle exec jekyll build` (output goes to `_site/`, which is gitignored — never edit it)

There are no tests or linters.

## Structure and conventions

- Content pages are Markdown (kramdown) with frontmatter (`title`, `layout: default`). Raw HTML is mixed in where styling is needed: `<p class="w3-code">` for code blocks, `<code class="w3-codespan">` for inline code.
- `_layouts/default.html` wraps content; `_includes/head.html` holds the nav sidebar, CSS links, and renders the site title as `<h1>` and the page title as `<h2>`. Section headings inside page content therefore start at `###` (h3).
- Styling is W3.CSS + Font Awesome, vendored under `assets/`. Local style changes go in `assets/overrides.css`, which loads last and wins ties — don't edit `w3.css`.
- kramdown auto-generates `id` anchors on headings, and `* TOC` / `{:toc}` (see `faq.md`) builds a table of contents from them automatically.
- HTML indentation is 2 spaces (see `website-design.md`).

## Gotchas

- `rmw_man.html` is groff-generated from the man page in the rmw source repo — regenerate it there, don't hand-edit it.
- The `dot_trashinfo` anchor in `faq.md` is linked from the rmw man page. Don't rename or remove it, and treat other heading anchors as public URLs once published.
