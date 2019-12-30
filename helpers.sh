# Takes an ISO-8601 datestamp and formats it as a "human" date.
formatDate() {
	if date --version | grep -q coreutils ; then
		# BSD and GNU `date`, turns out, are very different. Only GNU date
		# responds successfully to `--version`, so we're going to try and
		# support both based on that, grepping for coreutils to be absolutely
		# sure this is the date we expect.
		echo $(date -d "$1" +"%B %-d %Y")
	else
		echo $(date -jf "%Y-%m-%d" "$1" +"%B %-d %Y")
	fi
}

# Takes an ISO-8601 datestamp and formats it as an RFC-822 timestamp.
#
# Generally useful for RSS feeds' "pubDate".
formatRfc822Date() {
	if date --version | grep -q coreutils ; then
		# BSD and GNU `date`, turns out, are very different. Only GNU date
		# responds successfully to `--version`, so we're going to try and
		# support both based on that, grepping for coreutils to be absolutely
		# sure this is the date we expect.
		echo $(date -d "$1" +"%a, %d %b %Y 09:00:00 GMT")
	else
		echo $(date -jf "%Y-%m-%d" "$1" +"%a, %d %b %Y 09:00:00 GMT")
	fi

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
