#!/usr/bin/env bash

set -euf -o pipefail

. "./helpers.sh"

BUILD_DIR="./_build"

fancyLog() {
	echo "-------> ${@:-}"
}

render() {
	layout="${2:-site}"
	ext="html"

	[[ -e "src/$1.meta" ]] && eval "$(cat src/$1.meta)"

	if [[ "$1" =~ "articles/" ]] && [[ "$layout" != "article" ]] ; then
		# for articles, loop through render twice to wrap in the article layout
		content="$(render $1 article nowrite)"
	else
		# Otherwise just read the page contents
		if [[ -e "src/$1.xml" ]] ; then
			ext="xml"
		fi
		content="$(eval "cat <<-EOF
			$(<src/$1.$ext)
		EOF")"
	fi

	pageContent=$(eval "cat <<-EOF
		$(<src/_layouts/$layout.$ext)
	EOF")

	if [ "${3:-}" = "nowrite" ] ; then
		echo $pageContent
	else
		echo $pageContent > $BUILD_DIR/$page.$ext
	fi
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
	$(render $page)
done

fancyLog "Copying static assets"
mkdir -p "$BUILD_DIR/_"
cp -r src/_ "$BUILD_DIR"

ENDTIME="$(date +%s)"
echo
echo "Finished build at $(date)."
echo "Took approximately $(expr $ENDTIME - $STARTTIME)s"
echo "Resulting artefacts are located in '$BUILD_DIR'"
