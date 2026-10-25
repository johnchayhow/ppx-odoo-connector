#!/bin/bash
#
# Builds one importable zip per Odoo version, into dist/.
#
#   tools/build-zips.sh
#
# These are what you upload in Odoo Online: Apps -> Import Module. The zip has
# ppx_portal/ at its root, which is what the importer expects -- GitHub's own
# "Download ZIP" wraps everything in an extra folder and Odoo rejects it.
#
# Built with git archive, so what goes in is what is committed on that branch,
# never a stray local edit.
set -euo pipefail

VERSIONS=(17.0 18.0 19.0 20.0)
cd "$(dirname "$0")/.."

rm -rf dist
mkdir -p dist

for version in "${VERSIONS[@]}"; do
  if ! git show-ref --verify --quiet "refs/heads/$version"; then
    echo "  $version  no branch, skipped"
    continue
  fi

  work="$(mktemp -d)"
  git archive --format=tar "$version" ppx_portal | (cd "$work" && tar xf -)
  (cd "$work" && zip -qr "ppx_portal.zip" ppx_portal)
  mv "$work/ppx_portal.zip" "dist/ppx_portal-$version.zip"
  rm -rf "$work"

  manifest_version="$(git show "$version:ppx_portal/__manifest__.py" | sed -n "s/.*'version': '\([0-9.]*\)'.*/\1/p")"
  echo "  dist/ppx_portal-$version.zip   (manifest $manifest_version)"
done
