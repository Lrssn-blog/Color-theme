# AGENTS.md

Instructions for AI coding agents working in this repository.
For people, see `README.md`.

## Overview

This repository holds the Lrssn colour themes: Lrssn Hearth, which is dark, and Lrssn Shore, which is light.
Each theme is defined once, in `palette/`, and `scripts/build.py` generates the themes for every target from it.

## Commands

- Check the generated files and the contrast: `scripts/build.py`
- Regenerate the files after changing a palette or a template: `scripts/build.py --write`
- Render the wallpapers and the previews: `scripts/render-art.sh`
- Lint the Markdown: `npx markdownlint-cli2`
- Lint and type-check the scripts: `ruff check && ruff format --check` and `mypy scripts`
- Check the links: `lychee --config .lychee.toml '**/*.md'`

Run `scripts/build.py`, the Markdown lint, and Ruff and mypy before you say a task is done.

## Layout

- `palette/hearth.toml`, `palette/shore.toml`: the colours, as named roles.
- `templates/`: one template per generated file, with `{{ role }}` placeholders.
- `scripts/build.py`: renders the templates, writes the website maps, the Neovim palettes and the tables of `Theme.md`, and checks the contrast.
- `vscode/`, `colors/`, `lua/`, `terminal/`, `omarchy/`, `homarr/`, `website/`, `latex/`, `art/` and `preview/`: the generated themes.
- `vscode/package.json`, `lua/lrssn/init.lua` and `lua/lrssn/lualine.lua` are written by hand.
- `.github/workflows/`: CI.

## Conventions

- Follow the [Markdown style guide](https://github.com/Lrssn-blog/Style-guide/blob/main/src/markdown/Markdown.md).
  Write one sentence per line.
- Follow the [Python style guide](https://github.com/Lrssn-blog/Style-guide/blob/main/src/python/Python.md) and the [Bash style guide](https://github.com/Lrssn-blog/Style-guide/blob/main/src/bash/Bash.md) for the scripts.
- Never edit a generated file by hand.
  Change the palette or the template, and run `scripts/build.py --write`.
  `.gitattributes` lists the generated files.
- Give both palettes the same roles, in the same order.
- Keep the brand orange `#fc6600` as `primary` in both themes.
- When a contrast rule breaks, change the colour until it holds.
- Run `scripts/render-art.sh` after a change that shows in the wallpapers or the previews, and commit the PNG files.
- Write in British English, as the [brand guide](https://github.com/Lrssn-blog/Brand-guide) asks.

## Git and pull requests

- Follow the [Git style guide](https://github.com/Lrssn-blog/Style-guide/blob/main/src/git/Git.md) and the [Agentic development style guide](https://github.com/Lrssn-blog/Style-guide/blob/main/src/agentic/Agentic.md).
- `main` is the root branch.
  Work on a branch from `main`, and never commit to `main`.
- Open a pull request only when asked, against `main`.

## Boundaries

Ask first:

- Changing CI, the build script's contrast rules or the lint configuration.
- Adding a dependency.
- Removing a role or a target.

Never:

- Skip, weaken or disable a check to make it pass.
- Commit secrets.
