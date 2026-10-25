#!/bin/bash
#
# Copies the module from one branch onto every supported Odoo version branch,
# rewriting the manifest version for each.
#
#   tools/sync-versions.sh            # from the branch you are on
#   tools/sync-versions.sh 20.0       # from a named branch
#
# Why this exists: Odoo refuses to install a module whose manifest version
# series does not match the server ("incompatible version, setting
# installable=False"), so the Apps Store wants one branch per Odoo version.
# The code is identical on all of them -- only the version key differs -- and
# keeping four copies in step by hand is how one of them quietly falls behind.
#
# Edit the module on any branch, commit, then run this. It copies that branch's
# module onto the others and commits each, leaving you where you started.
set -euo pipefail

VERSIONS=(17.0 18.0 19.0 20.0)
cd "$(dirname "$0")/.."

SOURCE="${1:-$(git rev-parse --abbrev-ref HEAD)}"

if [ -n "$(git status --porcelain)" ]; then
  echo "Working tree has uncommitted changes. Commit them first, so there is"
  echo "something to copy and nothing to lose."
  exit 1
fi

if ! git show-ref --verify --quiet "refs/heads/$SOURCE"; then
  echo "No such branch: $SOURCE"
  exit 1
fi

STARTED_ON="$(git rev-parse --abbrev-ref HEAD)"
restore() { git checkout --quiet "$STARTED_ON"; }
trap restore EXIT

echo "Source: $SOURCE"

for version in "${VERSIONS[@]}"; do
  if [ "$version" = "$SOURCE" ]; then
    echo "  $version  (source)"
    continue
  fi

  if git show-ref --verify --quiet "refs/heads/$version"; then
    git checkout --quiet "$version"
  else
    git checkout --quiet -b "$version" "$SOURCE"
  fi

  # Everything that is shared. The manifest is overwritten too and then has its
  # version put back, so a change to any other manifest key propagates.
  git checkout --quiet "$SOURCE" -- ppx_portal README.md LICENSE .gitignore tools

  # x.y.1.0.0 -- Odoo reads the leading series and ignores the rest.
  perl -pi -e "s/'version': '[0-9.]+'/'version': '${version}.1.0.0'/" ppx_portal/__manifest__.py

  if [ -z "$(git status --porcelain)" ]; then
    echo "  $version  already current"
    continue
  fi

  git add -A
  git commit --quiet -m "Sync module from $SOURCE

Same code as the other version branches; the manifest version is what differs,
because Odoo will not install a module whose version series does not match the
server it is installed on."
  echo "  $version  updated"
done

echo
echo "Done. Push each branch you want published:"
printf '  git push origin %s\n' "${VERSIONS[@]}"
