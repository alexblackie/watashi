#!/usr/bin/env bash

set -euf -o pipefail

. "./helpers.sh"

BUILD_DIR="./_build"

fancyLog() {
	echo "-------> ${@:-}"
}

render() {
	layout="${2:-site}"

	[[ -e "src/$1.meta" ]] && eval "$(cat src/$1.meta)"

	if [[ "$1" =~ "articles/" ]] && [[ "$layout" != "article" ]] ; then
		# for articles, loop through render twice to wrap in the article layout
		content="$(render $1 article)"
	else
		# Otherwise just read the page contents
		content="$(eval "cat <<-EOF
			$(<src/$1.html)
		EOF")"
	fi

	eval "cat <<-EOF
		$(<src/_layouts/$layout.html)
	EOF"
}

STARTTIME="$(date +%s)"
echo "Starting build at $(date)"
echo

mkdir -p "$BUILD_DIR"

for sourceTemplate in $(find src -name '*.meta' | sed 's/src\///') ; do
	page="${sourceTemplate/.meta/}"
	fancyLog "Compiling $page"
	mkdir -p $BUILD_DIR/$(dirname $page)

	# subshell to prevent data leakage between renders
	$(render $page > $BUILD_DIR/$page.html)
done

fancyLog "Copying static assets"
mkdir -p "$BUILD_DIR/_"
cp -r src/_/ "$BUILD_DIR/_/"

ENDTIME="$(date +%s)"
echo
echo "Finished build at $(date)."
echo "Took approximately $(expr $ENDTIME - $STARTTIME)s"
echo "Resulting artefacts are located in '$BUILD_DIR'"
