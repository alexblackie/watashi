# Takes an ISO-8601 datestamp and formats it as a "human" date.
formatDate() {
	if [ "$(uname -s)" = "Linux" ] ; then
		echo $(date -d "$1" +"%B %-d %Y")
	else
		echo $(date -jf "%Y-%m-%d" "$1" +"%B %-d %Y")
	fi
}

# Takes an ISO-8601 datestamp and formats it as an RFC-822 timestamp.
#
# Generally useful for RSS feeds' "pubDate".
formatRfc822Date() {
	if [ "$(uname -s)" = "Linux" ] ; then
		echo $(date -d "$1" +"%a, %d %b %Y 09:00:00 GMT")
	else
		echo $(date -jf "%Y-%m-%d" "$1" +"%a, %d %b %Y 09:00:00 GMT")
	fi
}

navHighlight() {
	target="$1"
	[ "$target" = "${nav:-}" ] && echo "active"
}

# Get the current build environment. If unset, `development` is assumed.
watashiEnv() {
	echo "${WATASHI_ENV:-development}"
}

# Get a list of all directories in `articles`, sorted by their metadata's
# $publishDate value.
#
# $1 - number of articles to return, default 10
# $2 - number of articles to offset by, default 0
listArticlesByDate() {
	bag=""
	limit="${1:-10}"
	offset="${2:-0}"

	set +f
	for articleDir in $(ls articles/) ; do
		eval "$(cat articles/$articleDir/index.meta)"
		bag="$bag$publishDate@articles/$articleDir\n"
	done
	set -f

	sorted=($(echo -e $bag | sort -r | tail -n +$offset | head -n $limit | cut -f2- -d'@'))
	echo "${sorted[*]}"
}

# Renders the given string as a template for each article. Useful for building
# index lists, or RSS feeds.
#
# Content is not loaded by default, for speed. Use `getArticleContent/1`.
renderArticles() {
	maxCount="${1:-10}"
	articles=($(listArticlesByDate $maxCount))
	templateString="$(while read template ; do echo $template ; done)"

	for article in ${articles[@]} ; do
		eval "$(cat $article/index.meta)"
		eval "cat <<-EOF
			$templateString
		EOF"
	done
}

# Fetch and parse the HTML content that corresponds to the given article
# directory path.
getArticleContent() {
	eval "cat <<EOF
		$(<$1/index.html)
EOF"
}

# Generate syntax-highlighted code blocks using Chroma, a pygments-compatible
# Go application.
highlight() {
	chroma -f html --html-only -l "$1"
}

# Determine if an article is old (> 2 years)
isThisOld() {
	if [ "${2:-}" = "true" ] ; then
		# If "evergreen=true" on the article, then don't render the warning,
		# even if it's technically old.
		return
	fi

	warningContent="$(while read c; do echo $c; done)"

	if [ "$(uname -s)" = "Linux" ] ; then
		postedAt=$(date --date="$1" +%s)
		twoYearsAgo=$(date --date="-2 years" +%s)
	else
		postedAt=$(date -jf "%Y-%m-%d" "$1" +%s)
		twoYearsAgo=$(date -jv"-2y" +%s)
	fi


	if [ "$twoYearsAgo" -gt "$postedAt" ] ; then
		cat <<-EOF
		$warningContent
		EOF
	fi
}

# Takes a single argument, an icon name, and returns the SVG content for
# embedding inline.
icon() {
	cat "icons/$1.svg"
}
