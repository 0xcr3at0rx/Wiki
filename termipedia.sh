#!/bin/sh
set -eu

API="https://en.wikipedia.org/w/api.php"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/termipedia"
mkdir -p "$CACHE_DIR"

BLUE="$(printf '\033[34m')"
RESET="$(printf '\033[0m')"

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS] <query>

Search and view Wikipedia articles from the terminal.

Options:
  -n, --no-cache    Disable cache
  -h, --help        Show this help message

Examples:
  $(basename "$0") linux
  $(basename "$0") "quantum mechanics"
EOF
}

NO_CACHE=0
QUERY=""

while [ $# -gt 0 ]; do
    case "$1" in
        -n|--no-cache) NO_CACHE=1 ;;
        -h|--help) usage; exit 0 ;;
        *) QUERY="$QUERY $1" ;;
    esac
    shift
done

# Trim leading space
QUERY=$(printf "%s" "$QUERY" | sed 's/^ *//')

# Show help if no query provided
if [ -z "$QUERY" ]; then
    usage
    exit 1
fi

for cmd in curl jq fzf; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Error: '$cmd' is required but not installed." >&2
        exit 1
    }
done

cache_file() {
    printf "%s/%s.json" "$CACHE_DIR" "$1"
}

fetch() {
    URL="$1"
    FILE="$2"

    if [ "$NO_CACHE" -eq 0 ] && [ -f "$FILE" ]; then
        cat "$FILE"
    else
        curl -fsSL --retry 2 --connect-timeout 5 --max-time 10 "$URL" | tee "$FILE"
    fi
}

render() {
    TEXT="# $1

$2"

    printf "%s\n" "$TEXT" | less
}

article() {
    TITLE_RAW="$1"
    TITLE_ENC=$(printf '%s' "$TITLE_RAW" | jq -sRr @uri)

    FILE=$(cache_file "$TITLE_ENC")

    RES=$(fetch \
        "$API?action=query&titles=$TITLE_ENC&prop=extracts|pageprops&explaintext=1&format=json&redirects=1" \
        "$FILE" || true)

    [ -z "$RES" ] && return 1

    TITLE=$(printf '%s' "$RES" | jq -r '.query.pages | to_entries[0].value.title // empty')
    BODY=$(printf '%s' "$RES" | jq -r '.query.pages | to_entries[0].value.extract // empty')
    DISAMBIG=$(printf '%s' "$RES" | jq -r '.query.pages | to_entries[0].value.pageprops.disambiguation? // empty')

    [ -z "$TITLE" ] && return 1

    # DISAMBIGUATION HANDLING
    if [ -n "$DISAMBIG" ]; then
        SEL=$(curl -fsSL --retry 2 \
            "$API?action=query&titles=$TITLE_ENC&prop=links&pllimit=max&format=json" \
        | jq -r '.query.pages | to_entries[0].value.links[].title' \
        | grep -v ":" \
        | fzf \
            --prompt="${BLUE}Select > ${RESET}" \
            --preview "
t=\$(printf '%s' {} | jq -sRr @uri)
curl -fsSL '$API?action=query&titles='\$t'&prop=extracts&explaintext=1&format=json' 2>/dev/null \
| jq -r '.query.pages | to_entries[0].value.extract // \"\"' | head -n 20
")

        [ -z "$SEL" ] && return 0
        article "$SEL"
        return
    fi

    render "$TITLE" "$BODY"
}

# SEARCH + SELECT
SEL=$(curl -fsSL --retry 2 \
    "$API" \
    --data-urlencode "action=query" \
    --data-urlencode "list=search" \
    --data-urlencode "srsearch=$QUERY" \
    --data-urlencode "format=json" \
    --data-urlencode "srlimit=20" \
| jq -r '.query.search[].title' \
| fzf \
    --prompt="${BLUE}Wiki > ${RESET}" \
    --preview "
t=\$(printf '%s' {} | jq -sRr @uri)
curl -fsSL '$API?action=query&titles='\$t'&prop=extracts&explaintext=1&format=json' 2>/dev/null \
| jq -r '.query.pages | to_entries[0].value.extract // \"\"' | head -n 20
")

[ -z "$SEL" ] && exit 0

article "$SEL"
