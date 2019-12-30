# Takes an ISO-8601 datestamp and formats it as a "human" date.
formatDate() {
	echo $(date -d "$1" +"%B %-d %Y")
}

# Takes an ISO-8601 datestamp and formats it as an RFC-822 timestamp.
#
# Generally useful for RSS feeds' "pubDate".
formatRfc822Date() {
	echo $(date -d "$1" +"%a, %d %b %Y 09:00:00 GMT")
}

# Get a list of all directories in `articles`, sorted by their metadata's
# $publishDate value.
listArticlesByDate() {
	bag=""

	set +f
	for articleDir in $(ls articles/) ; do
		eval "$(cat articles/$articleDir/index.meta)"
		bag="$bag$publishDate@articles/$articleDir\n"
	done
	set -f

	sorted=($(echo -e $bag | sort -r | cut -f2- -d'@'))
	echo "${sorted[*]}"
}

# Renders the given string as a template for each article. Useful for building
# index lists, or RSS feeds.
#
# Content is not loaded by default, for speed. Use `getArticleContent/1`.
renderArticles() {
	articles=($(listArticlesByDate))
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

# Generate syntax-highlighted code blocks using python's pygments library.
highlight() {
  pygmentize -f html -l "$1"
}

# Determine if an article is old (> 2 years)
isThisOld() {
  warningContent="$(while read c; do echo $c; done)"
  postedAt=$(date --date="$1" +%s)
  twoYearsAgo=$(date --date="-2 years" +%s)
  if [ "$twoYearsAgo" -gt "$postedAt" ] ; then
    cat <<-EOF
    $warningContent
EOF
  fi
}
