# Takes an ISO-8601 datestamp and formats it as a "human" date.
formatDate() {
	if date --version >/dev/null 2>&1 ; then
		# BSD and GNU `date`, turns out, are very different. Only GNU date
		# responds successfully to `--version`, so we're going to try and
		# support both based on that.
		echo $(date -d "$1" +"%B %-d %Y")
	else
		echo $(date -jf "%Y-%m-%d" "$1" +"%B %-d %Y")
	fi

}

# Renders a table row for each article in `src/articles`, sorted by publishDate
allArticles() {
	result=""
	databag=()
	i=0

	for article in $(find src/articles -name '*.meta' | sed 's/src\///') ; do
		eval "$(cat src/$article)"
		databag[$i]="$publishDate $article"
		i=$(expr $i + 1)
	done

	IFS=$'\n'
	sorted=($(sort -r <<<"${databag[*]}"))
	templateString="$(while read template ; do echo $template ; done)"

	for row in ${sorted[*]} ; do
		article="$(echo $row | cut -f2- -d' ')"
		eval "$(cat src/$article)"
		content="$(eval "cat <<-EOF
			$(<src/${article/.meta/.html})
		EOF")"
		eval "cat <<-EOF
			$templateString
		EOF"
	done
	unset IFS
}
