# Takes an ISO-8601 datestamp and formats it as a "human" date.
formatDate() {
	echo $(date -jf "%Y-%m-%d" "$1" +"%B %-d %Y")
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

	for row in ${sorted[*]} ; do
		article="$(echo $row | cut -f2- -d' ')"
		eval "$(cat src/$article)"
		echo "<tr><td>$(formatDate $publishDate)</td><td><a href=\"/$(dirname $article)/\">$title</a></td></tr>"
	done
	unset IFS
}
