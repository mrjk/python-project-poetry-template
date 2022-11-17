#!/usr/bin/env bash

set -e
[ -z "$DEBUG" ] || set -x;

usage() {
  echo "$0 <repo> <tag> [<release name>] [-- <asset>...]" >&2;
}

if [ "$1" = "-h" -o "$1" = "--help" ]; then
  usage
  cat >&2 <<EOS

Pass the following arguments:

	* \`<repo>\`: ":user/:name" of the repository. For example, "foca/mpp".
	* \`<tag>\`: Name of the tag for this release. For example, "v1.0.0".
	* \`<release name>\`: Optional suffix for the release name.

You can pass a list of files to upload as release assets by giving them after a
\`--\` argument.

If you supply text on \`STDIN\` it will be used as the release notes.

EXAMPLES:

	$ $0 foca/mpp v1.0.0 -- pkg/*.tar.gz

	Creates a release named "mpp v1.0.0" and adds any tar.gz file in
	\`./pkg\` as an asset.

	$ $0 foca/mpp v1.0.1 "Bugfixes" -- pkg/*.tar.gz < notes.md

	Creates a release named "mpp v1.0.1: Bugfixes", adds any tar.gz
	file in \`./pkg\` as an asset, and uses the contents of \`notes.md\`
	as the release notes.

NOTE:

This uses your \`.netrc\` file to authenticate with GitHub. In order to run the
script, make sure you have **both** \`api.github.com\` and \`upload.github.com\` in
this file. For example:

machine api.github.com
  login foca
  password <an access token>
machine upload.github.com
  login foca
  password <an access token>

Generate this access token at https://github.com/settings/tokens and make sure
it has access to the \`"repo"\` scope.
EOS
  exit 1;
fi

#[ -n "$2" ] || (usage; exit 1);

REPO="$1"
shift
#REPO="$(git config --get remote.origin.url)"

#TAG="$1"
#shift
TAG="$(git describe --tags --abbrev=0 --exact-match 2>/dev/null || true )"

if [[ -z "$TAG" ]]; then
  echo "Not allowed to publish version from not a tag commit"
  exit 1
fi

NAME="$(basename "$REPO") ${TAG}"
if [ -n "$1" -a "$1" != "--" ]; then
  NAME="${NAME}: $1";
  shift
fi

BODY=""
[ -t 0 ] || BODY=`cat`;

if [ "$1" = "--" -a "$#" -ge "2" ]; then
  shift
  ASSETS="$@"
fi

set -x

# https://docs.github.com/en/rest/releases/releases#create-a-release
payload=$(
  jq --null-input \
     --arg tag "$TAG"  \
     --arg name "$TAG NEW" \
     --arg body "$NAME$BODY" \
     --arg latest "true" \
     --arg target "$TAG" \
     '{ tag_name: $tag, name: $name, body: $body, draft: true, make_latest: $latest }'
     #'{ tag_name: $tag, name: $name, body: $body, draft: true, make_latest: $latest, target_commitish: $target }'
)

       #--silent \
       #--location \
response=$(
  curl --fail \
       --netrc \
       -H "Accept: application/vnd.github+json" \
       -H "Authorization: Bearer $GH_TOKEN" \
       --data "$payload" \
       "https://api.github.com/repos/${REPO}/releases"
)

# See: https://docs.github.com/en/rest/releases/assets#upload-a-release-asset
upload_url="$(echo "$response" | jq -r .upload_url | sed -e "s/{?name,label}//")"

for file in $ASSETS; do
  curl --netrc \
       -X PATCH \
       -H "Accept: $(file -b --mime-type $file)" \
       -H "Authorization: Bearer $GH_TOKEN" \
       --data-binary "@$file" \
       "$upload_url?name=$(basename "$file")"
done

# Copyright (c) 2016 Nicolas Sanguinetti <hi@nicolassanguinetti.info>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
