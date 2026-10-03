#!/usr/bin/env bash
# Points Casks/freshkube.rb at the newest published Freshkube release, drafts
# excluded and pre-releases included, with the checksums the release ships.
# Prints the new version when the cask changed, nothing otherwise.
set -euo pipefail

repo=skel84/freshkube
cask="$(dirname "$0")/../Casks/freshkube.rb"

tag=$(curl -fsSL "https://api.github.com/repos/$repo/releases?per_page=20" |
  python3 -c 'import json, sys
releases = [r for r in json.load(sys.stdin) if not r["draft"]]
print(releases[0]["tag_name"] if releases else "")')
[ -n "$tag" ] || { echo "no published release" >&2; exit 1; }
version=${tag#v}

current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")
[ "$version" != "$current" ] || exit 0

checksum() {
  local name="Freshkube-$version-$1-apple-darwin-adhoc.zip"
  curl -fsSL "https://github.com/$repo/releases/download/$tag/$name.sha256" |
    awk -v name="$name" '$2 == name { print $1 }'
}
arm=$(checksum aarch64)
intel=$(checksum x86_64)
[[ $arm =~ ^[0-9a-f]{64}$ && $intel =~ ^[0-9a-f]{64}$ ]] ||
  { echo "missing checksums for $tag" >&2; exit 1; }

sed -i.bak \
  -e "s/^  version \".*\"$/  version \"$version\"/" \
  -e "s/^  sha256 arm:   \".*\",$/  sha256 arm:   \"$arm\",/" \
  -e "s/^         intel: \".*\"$/         intel: \"$intel\"/" \
  "$cask"
rm "$cask.bak"
echo "$version"
