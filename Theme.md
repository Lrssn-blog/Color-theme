# Lrssn colour themes

The Lrssn colour themes come in two versions: **Lrssn Hearth**, which is dark, and **Lrssn Shore**, which is light.
Both are built around the brand orange `#fc6600`.
This guide is for anyone who changes the colours, or uses them for something new.
To install a theme, see the [README](./README.md).

## Table of contents

[TOC]

## The themes

### Lrssn Hearth

A cottage on New Year's Eve: warm inside, by a log fire, and cold outside, where fireworks go off over the snow.

- The surfaces are the smoked timber of the room, and the text is candlelight.
- The fire gives the orange keywords, the gold functions and the ember tags.
- The frost outside gives the cool blue comments, line numbers and borders, and the icy types.
- The fireworks give the pops: pink numbers, violet built-ins and green sparkler strings.

### Lrssn Shore

A warm summer evening on a beach, with a bonfire.

- The surfaces are warm sand, and the text is the deep water of the lagoon.
- The bonfire gives the orange keywords and the cursor.
- The clear tropical water gives the blue functions, the teal strings and the reef-blue types.
- The corals give the pops: pink numbers, red tags and purple built-ins.
- Driftwood gives the comments.

## Principles

- **Have one source for each colour.**
  Each theme is defined once, in [`palette/hearth.toml`](./palette/hearth.toml) and [`palette/shore.toml`](./palette/shore.toml).
  Every other file is generated from them by `scripts/build.py`.
- **Be readable first.**
  Every text colour reaches a contrast ratio of 4.5 on every surface, and the build fails if one does not.
- **Keep the brand orange.**
  `primary` is `#fc6600` in both themes.
  It is for fills, rules and the logo, and orange text uses `primary-text`.
  Text on an orange fill uses `on-primary`, and never white.
- **Tell the story.**
  The themes follow the scenes above, rather than the brand guide's rule to keep the neutrals cool.
  Their neutrals are warm timber and warm sand on purpose.
- **Give each role one meaning.**
  A colour means the same thing in the editor, the terminal, the website and a PDF.

## Roles

Each palette has the same roles, in the same order.
A value is a HEX colour, or `@role` for the value of another role in `[colors]`.

| Group | Roles | Use |
| --- | --- | --- |
| Surfaces | `bg`, `bg-dim`, `bg-deep`, `bg-line`, `bg-raised` | The editor and the terminal, the sidebars and panels, the title bars, the current line, and popups. |
| Selection and lines | `selection`, `border`, `shadow` | Selected text, borders and dividers, and shadows under popups. |
| Text | `fg`, `fg-bright`, `fg-muted`, `fg-subtle`, `comment` | Text, strong text, secondary text, line numbers and inactive items, and comments. |
| Brand | `primary`, `primary-text`, `primary-soft`, `on-primary`, `accent` | The brand orange, orange text, an orange tint, text on orange, and the cursor and focus. |
| Secondary | `secondary`, `secondary-text`, `secondary-soft` | The cool accent: ice in Hearth, and tropical water in Shore. |
| Syntax | `keyword`, `function`, `string`, `number`, `type`, `builtin`, `tag`, `property`, `parameter`, `operator`, `punctuation`, `escape` | Code. |
| Status | `error`, `warning`, `info`, `hint`, `success` | Diagnostics and messages. |
| Diff | `added`, `removed`, `changed`, `added-soft`, `removed-soft`, `changed-soft` | Version control: the text, and the background of a changed line. |

Three more tables hold colours for one target:

- `[ansi]`: the 16 colours of the terminal.
- `[omarchy]`: the colours that only Omarchy uses.
- `[website]`: the 51 tokens of the Lrssn website, in the order of its stylesheet.

`accent` is the brand orange in Hearth.
In Shore it is a deeper orange, `#e05a00`, because `#fc6600` has a contrast ratio of only 2.78 on sand, and a cursor needs at least 3.

## Palette

<!-- generated:palette -->
| Role | Lrssn Hearth | Lrssn Shore |
| --- | --- | --- |
| `bg` | `#1a1512` | `#fdf6ea` |
| `bg-dim` | `#15110f` | `#f5ead7` |
| `bg-deep` | `#0f0c0a` | `#ecdfc8` |
| `bg-line` | `#211a16` | `#f8eedd` |
| `bg-raised` | `#2a211c` | `#fffbf4` |
| `selection` | `#47301f` | `#c6ebef` |
| `border` | `#2e343c` | `#e3d3b9` |
| `shadow` | `#000000` | `#6b4a2a` |
| `fg` | `#f0e3d0` | `#13303d` |
| `fg-bright` | `#fff6e8` | `#0a1f29` |
| `fg-muted` | `#a3aebb` | `#4f6470` |
| `fg-subtle` | `#6b7684` | `#7c898e` |
| `comment` | `#8796aa` | `#76664e` |
| `primary` | `#fc6600` | `#fc6600` |
| `primary-text` | `#ff8a3d` | `#b04600` |
| `primary-soft` | `#3a1f0e` | `#ffe3cc` |
| `on-primary` | `#14171c` | `#14171c` |
| `accent` | `#fc6600` | `#e05a00` |
| `secondary` | `#4d94b8` | `#00999a` |
| `secondary-text` | `#8cc8e3` | `#00737a` |
| `secondary-soft` | `#142430` | `#d2f1ee` |
| `keyword` | `#fc6600` | `#b04600` |
| `function` | `#ffb547` | `#00629c` |
| `string` | `#a9d48f` | `#00756a` |
| `number` | `#ff88c8` | `#c2215a` |
| `type` | `#7fcbe6` | `#3550b0` |
| `builtin` | `#c4a5ff` | `#8a3fbf` |
| `tag` | `#ff6b4f` | `#bd3722` |
| `property` | `#ebc69d` | `#7a5000` |
| `parameter` | `#f7d2aa` | `#6a4b33` |
| `operator` | `#f09a62` | `#a4521c` |
| `punctuation` | `#a8998b` | `#6b6152` |
| `escape` | `#ffe08a` | `#b02f86` |
| `error` | `#ff6b5e` | `#c4262e` |
| `warning` | `#ffb547` | `#965a00` |
| `info` | `#7fcbe6` | `#00629c` |
| `hint` | `#a9d48f` | `#00756a` |
| `success` | `#a9d48f` | `#1c7448` |
| `added` | `#93c97c` | `#24773f` |
| `removed` | `#ff6b5e` | `#c4262e` |
| `changed` | `#ffb547` | `#8f5e00` |
| `added-soft` | `#1e2a18` | `#dcf0dc` |
| `removed-soft` | `#361815` | `#fbe0dc` |
| `changed-soft` | `#33260f` | `#fbecc9` |
<!-- end:palette -->

## Terminal colours

<!-- generated:ansi -->
| Role | Lrssn Hearth | Lrssn Shore |
| --- | --- | --- |
| `ansi.black` | `#2a211c` | `#13303d` |
| `ansi.red` | `#ff6b5e` | `#bd3722` |
| `ansi.green` | `#a9d48f` | `#2b7a3f` |
| `ansi.yellow` | `#ffb547` | `#946000` |
| `ansi.blue` | `#86aaea` | `#00629c` |
| `ansi.magenta` | `#ff88c8` | `#c2215a` |
| `ansi.cyan` | `#7fcbe6` | `#00756a` |
| `ansi.white` | `#e3d4bf` | `#e8dcc6` |
| `ansi.bright-black` | `#6b7684` | `#6f7c81` |
| `ansi.bright-red` | `#ff9083` | `#e0533a` |
| `ansi.bright-green` | `#c3e5aa` | `#3d9a55` |
| `ansi.bright-yellow` | `#ffd47a` | `#b87d00` |
| `ansi.bright-blue` | `#abc4f3` | `#1a7fc4` |
| `ansi.bright-magenta` | `#ffb0dc` | `#d94a85` |
| `ansi.bright-cyan` | `#a9e0f2` | `#00928a` |
| `ansi.bright-white` | `#fff6e8` | `#fffbf4` |
<!-- end:ansi -->

## Contrast

The ratios are calculated with the [WCAG 2.2 contrast formula](https://www.w3.org/TR/WCAG22/#contrast-minimum).
Body text needs a ratio of at least 4.5, and large text and graphics need at least 3.

`scripts/build.py` checks these rules, and fails if one breaks:

- Every text and syntax colour reaches 4.5 on `bg`, `bg-dim`, `bg-line` and `bg-raised`.
- `fg-subtle` and `accent` reach 3 on `bg` and `bg-line`.
- `fg` reaches 4.5 on `selection` and on the diff backgrounds.
- Text on a fill or a tint reaches 4.5: `on-primary` on `primary`, `primary-text` on `primary-soft` and `secondary-text` on `secondary-soft`.
- The six terminal colours reach 4.5 on `bg`, and their bright versions reach 3.
- The website's text tokens reach 4.5 on its page and its surface, and each banner's text reaches 4.5 on its background.

The ratio of each text colour on `bg`:

<!-- generated:contrast -->
| Role | Lrssn Hearth | Lrssn Shore |
| --- | --- | --- |
| `fg` | 14.31 | 12.88 |
| `fg-bright` | 16.90 | 15.75 |
| `fg-muted` | 8.04 | 5.77 |
| `comment` | 6.01 | 5.17 |
| `primary-text` | 7.72 | 5.25 |
| `secondary-text` | 9.90 | 5.24 |
| `keyword` | 6.07 | 5.25 |
| `function` | 10.30 | 6.06 |
| `string` | 10.78 | 5.21 |
| `number` | 8.28 | 5.34 |
| `type` | 9.99 | 6.68 |
| `builtin` | 8.77 | 5.52 |
| `tag` | 6.44 | 5.24 |
| `property` | 11.29 | 6.57 |
| `parameter` | 12.72 | 7.33 |
| `operator` | 8.19 | 5.14 |
| `punctuation` | 6.55 | 5.65 |
| `escape` | 14.04 | 5.43 |
| `error` | 6.48 | 5.34 |
| `warning` | 10.30 | 5.20 |
| `info` | 9.99 | 6.06 |
| `hint` | 10.78 | 5.21 |
| `success` | 10.78 | 5.37 |
| `added` | 9.39 | 5.16 |
| `removed` | 6.48 | 5.34 |
| `changed` | 10.30 | 5.19 |
<!-- end:contrast -->

## Changing a colour

1. Change the value in `palette/hearth.toml` or `palette/shore.toml`.
2. Run `scripts/build.py --write` to regenerate the files.
3. Run `scripts/build.py` to check the contrast.
   If a rule breaks, adjust the colour until it holds, rather than loosening the rule.
4. Look at both themes in [`preview/index.html`](./preview/index.html).

To add a role, add it to both palettes in the same place, and use it in a template.
To add a target, add a template to `templates/` and its output path to `PER_THEME` or `COMBINED` in `scripts/build.py`.

## See also

- [README](./README.md)
- [Lrssn brand guide](https://github.com/Lrssn-blog/Brand-guide)
- [Lrssn design system](https://github.com/Lrssn-blog/Design-system)
- [Lrssn style guides](https://github.com/Lrssn-blog/Style-guide)
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
