#!/usr/bin/env bash
#
# Render the wallpapers in art/ and the previews of the Omarchy themes to PNG.
#
# Run it after `scripts/build.py --write` when a palette changes. It needs the
# Chromium headless shell, because the full browser in headless mode leaves a
# blank band at the bottom of a screenshot.
#
# Usage: scripts/render-art.sh
#   CHROME=/path/to/headless_shell scripts/render-art.sh

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly ROOT
readonly THEMES=(hearth shore)

err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
}

# Find a Chromium headless shell.
# Globals:
#   CHROME, PLAYWRIGHT_BROWSERS_PATH, HOME
# Outputs:
#   Writes the path of the shell to STDOUT.
# Returns:
#   0 if a shell was found, 1 otherwise.
find_chrome() {
    if [[ -n "${CHROME:-}" ]]; then
        echo "${CHROME}"
        return 0
    fi
    local name
    for name in chrome-headless-shell headless_shell; do
        if command -v "${name}" > /dev/null; then
            command -v "${name}"
            return 0
        fi
    done
    local browsers="${PLAYWRIGHT_BROWSERS_PATH:-${HOME}/.cache/ms-playwright}"
    local shell
    for shell in "${browsers}"/chromium_headless_shell-*/chrome-linux/headless_shell; do
        if [[ -x "${shell}" ]]; then
            echo "${shell}"
            return 0
        fi
    done
    return 1
}

# Take a screenshot of a page.
# Arguments:
#   The path of the Chromium headless shell.
#   The URL of the page.
#   The size of the window, as WIDTH,HEIGHT.
#   The path of the PNG to write.
screenshot() {
    local chrome="$1"
    local url="$2"
    local size="$3"
    local output="$4"
    local flags=(--disable-gpu --hide-scrollbars --virtual-time-budget=5000)
    # Chromium refuses to run as root without this, as in a container.
    if [[ "${EUID}" -eq 0 ]]; then
        flags+=(--no-sandbox)
    fi
    mkdir -p "$(dirname "${output}")"
    "${chrome}" "${flags[@]}" --window-size="${size}" \
        --screenshot="${output}" "${url}" 2> /dev/null
    echo "Wrote ${output#"${ROOT}"/}"
}

main() {
    local chrome
    if ! chrome="$(find_chrome)"; then
        err "Found no Chromium headless shell. Set CHROME to its path."
        exit 1
    fi
    local theme
    for theme in "${THEMES[@]}"; do
        local folder="${ROOT}/omarchy/lrssn-${theme}"
        screenshot "${chrome}" "file://${ROOT}/art/${theme}.html" 3840,2160 \
            "${folder}/backgrounds/1-lrssn-${theme}.png"
        screenshot "${chrome}" \
            "file://${ROOT}/preview/index.html?only=${theme}" 1600,1000 \
            "${folder}/preview.png"
    done
}

main "$@"
