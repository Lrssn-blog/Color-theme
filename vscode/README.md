# Lrssn Hearth and Shore for VS Code

Two colour themes built around the Lrssn orange, `#fc6600`.

- **Lrssn Hearth** is dark: a cottage on New Year's Eve, warm by the log fire while fireworks go off in the cold outside.
- **Lrssn Shore** is light: a summer evening on a beach, with a bonfire, clear tropical water and coral.

The themes colour the editor, the workbench, the syntax, the semantic tokens and the integrated terminal.

## Install

Link this folder into the extensions folder of VS Code, and restart VS Code:

```bash
ln -s "$PWD" ~/.vscode/extensions/lrssn.lrssn-themes-1.0.0
```

On Windows, copy the folder to `%USERPROFILE%\.vscode\extensions\lrssn.lrssn-themes-1.0.0` instead.

Then run **Preferences: Color Theme** and choose **Lrssn Hearth** or **Lrssn Shore**.

To package the extension as a `.vsix` file, run `npx @vscode/vsce package` in this folder, and install the file with **Extensions: Install from VSIX**.

## Follow the system theme

To use Hearth when the system is dark and Shore when it is light, add this to your `settings.json`:

```json
{
  "window.autoDetectColorScheme": true,
  "workbench.preferredDarkColorTheme": "Lrssn Hearth",
  "workbench.preferredLightColorTheme": "Lrssn Shore"
}
```

## Changing the colours

The theme files in `themes/` are generated, so do not edit them.
Change the palette in `palette/` or the template `templates/vscode.json` at the root of the repository, and run `scripts/build.py --write`.
