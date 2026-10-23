#!/usr/bin/env python3
"""Builds the Lrssn colour themes from their palettes.

Each theme is defined once, in palette/<theme>.toml.
This script renders the templates in templates/ with the colours of each
theme, writes the website tokens, the Neovim palettes and the tables of
Theme.md, and checks that every text colour has enough contrast.

Usage:
    scripts/build.py          Check that every generated file is up to date.
    scripts/build.py --write  Regenerate the files from the palettes.
"""

from collections.abc import Callable, Iterable
import dataclasses
import difflib
import json
import pathlib
import plistlib
import re
import sys
import tomllib

ROOT = pathlib.Path(__file__).resolve().parent.parent
PALETTES = ROOT / 'palette'
TEMPLATES = ROOT / 'templates'
GUIDE = ROOT / 'Theme.md'

# The themes, in the order they are shown.
THEMES = ('hearth', 'shore')

# Templates rendered once per theme, to a path with `{slug}` in it.
# The placeholders are the roles of one theme, such as `{{ bg }}`.
PER_THEME = {
    'vscode.json': 'vscode/themes/{slug}-color-theme.json',
    'nvim-colors.lua': 'colors/{slug}.lua',
    'nvim-lualine.lua': 'lua/lualine/themes/{slug}.lua',
    'alacritty.toml': 'terminal/alacritty/{slug}.toml',
    'ghostty': 'terminal/ghostty/{slug}',
    'kitty.conf': 'terminal/kitty/{slug}.conf',
    'windows-terminal.json': 'terminal/windows-terminal/{slug}.json',
    'iterm2.itermcolors': 'terminal/iterm2/{slug}.itermcolors',
    'omarchy-colors.toml': 'omarchy/{slug}/colors.toml',
    'omarchy-neovim.lua': 'omarchy/{slug}/neovim.lua',
    'omarchy-icons.theme': 'omarchy/{slug}/icons.theme',
}

# Templates rendered once, with the roles of every theme.
# The placeholders name the theme first, such as `{{ hearth.bg }}`.
COMBINED = {
    'lrssntheme.sty': 'latex/lrssntheme.sty',
    'preview.html': 'preview/index.html',
    'art-hearth.html': 'art/hearth.html',
    'art-shore.html': 'art/shore.html',
}

WEBSITE = 'website/_theme.scss'
NVIM_PALETTES = 'lua/lrssn/palettes.lua'

# The theme behind each map of the website's stylesheet.
WEBSITE_MAPS = (('theme-light', 'shore'), ('theme-dark', 'hearth'))

# The first token of each group of the website's maps, and its comment.
WEBSITE_GROUPS = {
    'primary-color': 'Brand',
    'background': 'Surfaces',
    'text-color': 'Text',
    'border-color': 'Borders',
    'success-color': 'Status',
    'banner-info-background': 'Banners',
    'tag-background-hover': 'Tags & media',
}

# Text roles, which must be readable on every surface.
TEXT_ROLES = (
    'fg',
    'fg-bright',
    'fg-muted',
    'comment',
    'primary-text',
    'secondary-text',
    'keyword',
    'function',
    'string',
    'number',
    'type',
    'builtin',
    'tag',
    'property',
    'parameter',
    'operator',
    'punctuation',
    'escape',
    'error',
    'warning',
    'info',
    'hint',
    'success',
    'added',
    'removed',
    'changed',
)
SURFACES = ('bg', 'bg-dim', 'bg-line', 'bg-raised')

# Body text needs 4.5, and large text and graphics need 3 (WCAG 2.2).
TEXT = 4.5
GRAPHICS = 3.0

ANSI_COLOURS = ('red', 'green', 'yellow', 'blue', 'magenta', 'cyan')

# Each rule is (foregrounds, backgrounds, minimum ratio).
Rule = tuple[Iterable[str], Iterable[str], float]
CONTRAST: tuple[Rule, ...] = (
    (TEXT_ROLES, SURFACES, TEXT),
    (('fg-subtle', 'accent'), ('bg', 'bg-line'), GRAPHICS),
    (
        ('fg',),
        ('selection', 'added-soft', 'removed-soft', 'changed-soft'),
        TEXT,
    ),
    (('on-primary',), ('primary',), TEXT),
    (('primary-text',), ('primary-soft',), TEXT),
    (('secondary-text',), ('secondary-soft',), TEXT),
    ([f'ansi.{name}' for name in ANSI_COLOURS], ('bg',), TEXT),
    ([f'ansi.bright-{name}' for name in ANSI_COLOURS], ('bg',), GRAPHICS),
    (('ansi.bright-black',), ('bg',), GRAPHICS),
    (
        [
            f'website.{name}'
            for name in (
                'text-color',
                'text-strong',
                'text-body',
                'text-muted',
                'text-subtle',
                'primary-text',
                'secondary-text',
                'link-color',
                'success-color',
                'danger-color',
                'resource-icon-color',
                'resource-kind-color',
            )
        ],
        ('website.background', 'website.surface'),
        TEXT,
    ),
    (('website.text-on-primary',), ('website.primary-color',), TEXT),
    (
        ('website.text-on-dark',),
        ('website.admin-header-background', 'website.notification-badge'),
        TEXT,
    ),
    (('website.border-color-input',), ('website.surface',), GRAPHICS),
    (('website.focus-color',), ('website.background',), GRAPHICS),
    *(
        (
            (f'website.banner-{banner}-color',),
            (f'website.banner-{banner}-background',),
            TEXT,
        )
        for banner in ('info', 'warning', 'error', 'success')
    ),
)
# Rules for the text colours of the terminal that depend on the mode.
MODE_CONTRAST: dict[str, tuple[Rule, ...]] = {
    'dark': ((('ansi.white', 'ansi.bright-white'), ('bg',), TEXT),),
    'light': ((('ansi.black',), ('bg',), TEXT),),
}

# Names that Lua reserves, which cannot be bare table keys.
LUA_KEYWORDS = frozenset(
    (
        'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for',
        'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or',
        'repeat', 'return', 'then', 'true', 'until', 'while',
    )
)  # fmt: skip

HEX = re.compile(r'^#[0-9a-f]{6}$')
# A placeholder such as `{{ bg }}`, `{{ hearth.bg }}` or `{{ bg | alpha 40 }}`.
PLACEHOLDER = re.compile(
    r'\{\{\s*([\w.-]+)\s*((?:\|\s*[\w-]+(?:\s+[\w.-]+)?\s*)*)\}\}'
)
MARKERS = re.compile(
    r'(<!-- generated:(\w+) -->\n).*?(<!-- end:\2 -->)', re.DOTALL
)


@dataclasses.dataclass(frozen=True)
class Theme:
    """A theme: its name, slug and mode, and the HEX value of each role.

    The roles of the table `[colors]` have no prefix, such as `bg`.
    The roles of the other tables have the table as a prefix, such as
    `ansi.red`.
    """

    key: str
    name: str
    slug: str
    mode: str
    roles: dict[str, str]
    tables: dict[str, list[str]]


def resolve(
    value: str, colors: dict[str, str], seen: tuple[str, ...] = ()
) -> str:
    """Returns the HEX colour of a value, following `@role` references."""
    if not value.startswith('@'):
        if not HEX.match(value):
            raise SystemExit(f'{value!r} is not a colour such as #fc6600')
        return value
    role = value[1:]
    if role in seen:
        raise SystemExit(f'{role}: refers to itself')
    if role not in colors:
        raise SystemExit(f'{value}: there is no such role in [colors]')
    return resolve(colors[role], colors, (*seen, role))


def load(key: str) -> Theme:
    """Reads the palette of a theme from palette/<key>.toml."""
    path = PALETTES / f'{key}.toml'
    data = tomllib.loads(path.read_text())
    meta = data.pop('meta')
    colors = data['colors']
    roles = {}
    tables = {}
    for table, values in data.items():
        prefix = '' if table == 'colors' else f'{table}.'
        tables[table] = list(values)
        for role, value in values.items():
            try:
                roles[prefix + role] = resolve(value, colors)
            except SystemExit as e:
                raise SystemExit(f'{path.name}: {prefix}{role}: {e}') from e
    return Theme(key, meta['name'], meta['slug'], meta['mode'], roles, tables)


def luminance(hex_value: str) -> float:
    """Returns the WCAG relative luminance of a colour such as '#fc6600'."""
    channels = []
    for start in (1, 3, 5):
        value = int(hex_value[start : start + 2], 16) / 255
        if value <= 0.03928:
            channels.append(value / 12.92)
        else:
            channels.append(((value + 0.055) / 1.055) ** 2.4)
    red, green, blue = channels
    return 0.2126 * red + 0.7152 * green + 0.0722 * blue


def contrast_ratio(first: str, second: str) -> float:
    """Returns the WCAG contrast ratio of two colours."""
    lighter, darker = sorted((luminance(first), luminance(second)))[::-1]
    return (lighter + 0.05) / (darker + 0.05)


def channel(start: int) -> Callable[[str, str], str]:
    """Returns a filter for one channel of a colour, as a fraction of 1."""

    def apply(value: str, _: str) -> str:
        return f'{int(value[start : start + 2], 16) / 255:.6f}'

    return apply


def alpha(value: str, argument: str) -> str:
    """Adds an opacity in percent to a colour, such as '#fc660066'."""
    if not argument.isdigit() or not 0 <= int(argument) <= 100:
        raise ValueError(f'alpha needs a percentage, not {argument!r}')
    return value + f'{round(int(argument) * 255 / 100):02x}'


FILTERS: dict[str, Callable[[str, str], str]] = {
    'alpha': alpha,
    'nohash': lambda value, _: value.lstrip('#'),
    'upper': lambda value, _: value.upper(),
    'r': channel(1),
    'g': channel(3),
    'b': channel(5),
}


def render(template: str, context: dict[str, str], name: str) -> str:
    """Replaces each placeholder of a template with its value."""

    def replace(match: re.Match[str]) -> str:
        role, filters = match.groups()
        if role not in context:
            raise SystemExit(f'templates/{name}: unknown role {role!r}')
        value = context[role]
        for step in filter(None, (s.strip() for s in filters.split('|'))):
            filter_name, _, argument = step.partition(' ')
            if filter_name not in FILTERS:
                raise SystemExit(
                    f'templates/{name}: unknown filter {filter_name!r}'
                )
            try:
                value = FILTERS[filter_name](value, argument.strip())
            except ValueError as e:
                raise SystemExit(f'templates/{name}: {e}') from e
        return value

    return PLACEHOLDER.sub(replace, template)


def context(theme: Theme) -> dict[str, str]:
    """Returns the placeholders of a theme.

    They are its roles, its name, slug and mode, and `css`: every role as a
    CSS custom property, such as `--bg-line` or `--ansi-red`.
    """
    css = '\n'.join(
        f'  --{role.replace(".", "-")}: {value};'
        for role, value in theme.roles.items()
    )
    return {
        **theme.roles,
        'name': theme.name,
        'slug': theme.slug,
        'mode': theme.mode,
        'css': css,
    }


def website(themes: dict[str, Theme]) -> str:
    """Returns the maps of the website's stylesheet for both themes."""
    lines = [
        '// Lrssn Shore and Lrssn Hearth for the Lrssn website.',
        '// Generated by scripts/build.py from palette/. Do not edit.',
        '//',
        '// Replace the maps `$theme-light` and `$theme-dark` in',
        '// src/styles/_variables.scss of Lrssn-com with the maps below.',
    ]
    for map_name, key in WEBSITE_MAPS:
        theme = themes[key]
        tokens = theme.tables['website']
        lines += ['', f'// {theme.name}', f'${map_name}: (']
        for index, token in enumerate(tokens):
            if token in WEBSITE_GROUPS:
                lines.append(f'\t// {WEBSITE_GROUPS[token]}')
            value = theme.roles[f'website.{token}']
            comma = ',' if index < len(tokens) - 1 else ''
            lines.append(f"\t'{token}': {value}{comma}")
        lines.append(');')
    return '\n'.join(lines) + '\n'


def lua_key(role: str) -> str:
    """Writes a role as a Lua table key, such as `bg_line` or `['function']`."""
    key = role.replace('-', '_')
    return f"['{key}']" if key in LUA_KEYWORDS else key


def nvim_palettes(themes: dict[str, Theme]) -> str:
    """Returns the Lua module with the palettes of every theme."""
    lines = [
        '-- The palettes of the Lrssn colour themes.',
        '-- Generated by scripts/build.py from palette/. Do not edit.',
        'return {',
    ]
    for theme in themes.values():
        lines += [f"  ['{theme.slug}'] = {{", f"    mode = '{theme.mode}',"]
        for role in theme.tables['colors']:
            lines.append(f"    {lua_key(role)} = '{theme.roles[role]}',")
        for table in ('ansi', 'omarchy'):
            lines.append(f'    {table} = {{')
            for role in theme.tables[table]:
                value = theme.roles[f'{table}.{role}']
                lines.append(f"      {lua_key(role)} = '{value}',")
            lines.append('    },')
        lines.append('  },')
    lines.append('}')
    return '\n'.join(lines) + '\n'


def guide_tables(themes: dict[str, Theme]) -> dict[str, str]:
    """Returns the generated tables of Theme.md, by the name of the marker."""
    ordered = [themes[key] for key in THEMES]
    header = '| Role | ' + ' | '.join(t.name for t in ordered) + ' |'
    rule = '| --- |' + ' --- |' * len(ordered)

    def rows(roles: Iterable[str]) -> list[str]:
        return [
            f'| `{role}` | '
            + ' | '.join(f'`{t.roles[role]}`' for t in ordered)
            + ' |'
            for role in roles
        ]

    colors = ordered[0].tables['colors']
    ansi = [f'ansi.{role}' for role in ordered[0].tables['ansi']]
    contrast = [
        f'| `{role}` | '
        + ' | '.join(
            f'{contrast_ratio(t.roles[role], t.roles["bg"]):.2f}'
            for t in ordered
        )
        + ' |'
        for role in TEXT_ROLES
    ]
    return {
        'palette': '\n'.join([header, rule, *rows(colors)]) + '\n',
        'ansi': '\n'.join([header, rule, *rows(ansi)]) + '\n',
        'contrast': '\n'.join([header, rule, *contrast]) + '\n',
    }


def fill_guide(text: str, tables: dict[str, str]) -> str:
    """Replaces the text between each pair of markers with its table."""

    def replace(match: re.Match[str]) -> str:
        start, name, end = match.groups()
        if name not in tables:
            raise SystemExit(f'{GUIDE.name}: unknown marker {name!r}')
        return start + tables[name] + end

    return MARKERS.sub(replace, text)


def outputs(themes: dict[str, Theme]) -> dict[str, str]:
    """Returns every generated file, as {path: content}."""
    files = {}
    for name, pattern in PER_THEME.items():
        template = (TEMPLATES / name).read_text()
        for theme in themes.values():
            path = pattern.format(slug=theme.slug)
            files[path] = render(template, context(theme), name)
    combined = {
        f'{theme.key}.{role}': value
        for theme in themes.values()
        for role, value in context(theme).items()
    }
    for name, path in COMBINED.items():
        files[path] = render((TEMPLATES / name).read_text(), combined, name)
    files[WEBSITE] = website(themes)
    files[NVIM_PALETTES] = nvim_palettes(themes)
    files[GUIDE.name] = fill_guide(GUIDE.read_text(), guide_tables(themes))
    return files


def check_palettes(themes: dict[str, Theme]) -> list[str]:
    """Checks that every theme has the same roles, in the same order."""
    errors = []
    first, *others = themes.values()
    for theme in others:
        for table, roles in first.tables.items():
            if theme.tables.get(table) != roles:
                errors.append(
                    f'[{table}] of {theme.name} has other roles, or another '
                    f'order, than {first.name}'
                )
    return errors


def check_contrast(themes: dict[str, Theme]) -> list[str]:
    """Checks every contrast rule in every theme."""
    errors = []
    for theme in themes.values():
        for foregrounds, backgrounds, minimum in (
            CONTRAST + MODE_CONTRAST[theme.mode]
        ):
            for foreground in foregrounds:
                for background in backgrounds:
                    ratio = contrast_ratio(
                        theme.roles[foreground], theme.roles[background]
                    )
                    if ratio < minimum:
                        errors.append(
                            f'{theme.name}: {foreground} on {background} is '
                            f'{ratio:.2f}, needs {minimum}'
                        )
    return errors


def check_syntax(files: dict[str, str]) -> list[str]:
    """Checks that the generated JSON, TOML and plist files can be parsed."""
    parsers: dict[str, Callable[[str], object]] = {
        '.json': json.loads,
        '.toml': tomllib.loads,
        '.itermcolors': lambda text: plistlib.loads(text.encode()),
    }
    errors = []
    for path, text in files.items():
        parse = parsers.get(pathlib.PurePath(path).suffix)
        if parse is None:
            continue
        try:
            parse(text)
        except (ValueError, plistlib.InvalidFileException) as e:
            errors.append(f'{path}: {e}')
    return errors


def main() -> None:
    """Checks or writes the generated files, and exits with 1 on an error."""
    write = sys.argv[1:] == ['--write']
    if sys.argv[1:] and not write:
        raise SystemExit(__doc__)
    themes = {key: load(key) for key in THEMES}
    errors = check_palettes(themes) + check_contrast(themes)
    files = outputs(themes)
    errors += check_syntax(files)
    stale = []
    for path, text in files.items():
        target = ROOT / path
        current = target.read_text() if target.exists() else ''
        if current == text:
            continue
        if write:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(text)
            print(f'Wrote {path}')
        else:
            stale.append(path)
            sys.stdout.writelines(
                difflib.unified_diff(
                    current.splitlines(keepends=True),
                    text.splitlines(keepends=True),
                    f'a/{path}',
                    f'b/{path}',
                )
            )
    for error in errors:
        print(error)
    if stale:
        print('Out of date: ' + ', '.join(stale))
        print('Run scripts/build.py --write to regenerate them.')
    if errors or stale:
        sys.exit(1)
    print(f'{len(files)} files are up to date, and every contrast rule holds.')


if __name__ == '__main__':
    main()
