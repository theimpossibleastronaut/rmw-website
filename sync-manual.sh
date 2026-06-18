#!/bin/sh
# Regenerate rmw_man.md from the rmw source repo's MANUAL.md.
#
# MANUAL.md is the single source for both the rmw(1) man page (generated there
# with go-md2man) and this website's manual page. This script copies it in and
# adapts it for Jekyll:
#   * adds front matter and a generated table of contents
#   * drops the go-md2man title line (the "RMW 1 ..." setext header)
#   * removes the HTML maintainer comments
#   * shifts headings down two levels so they sit under the site/page titles
#     (the layout renders the site title as h1 and the page title as h2)
#
# Usage: ./sync-manual.sh [path-to-MANUAL.md]   (default: ../rmw/MANUAL.md)
set -e

SRC="${1:-../rmw/MANUAL.md}"
OUT="rmw_man.md"

if [ ! -f "$SRC" ]; then
  echo "source not found: $SRC" >&2
  exit 1
fi

{
  printf -- '---\ntitle: rmw manual\nlayout: default\n---\n\n'
  printf -- '* TOC\n{:toc}\n\n'
  tail -n +3 "$SRC" \
    | perl -0777 -pe 's/<!--.*?-->\n*//gs' \
    | sed -E 's/^(#{1,4}) /\1## /'
} > "$OUT"

echo "wrote $OUT from $SRC"
