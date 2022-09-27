title: Automate commit co-authors when pairing
publishDate: "2021-08-03"
---
Pairing is a fantastic way to quickly bounce ideas around, get help with
something, or even as a tool for mentoring and growth. In recent times, most
Git-based tools have adopted the `Co-Authored-By` trailer to identify when
there are multiple authors to a commit. This is great, but often a pain to type
out manually, especially if there are many commits or multiple people involved.

Asking around at work, there were a few things people had &mdash; everything
from vim macros, to custom shell functions &mdash; but nothing quite like what
I wanted. So I wrote a script to do it for me.

It begins with `git-pair` (to be used as `git pair`). This script enumerates
all the commit authors in the current repo, offers them to you [with a
fuzzy-finder](https://github.com/jhawthorn/fzy), and then appends those people
as co-authors on every commit until you run a companion script to end the
session.

```bash
#!/usr/bin/env bash

set -uf -o pipefail

TEMPLATE_PATH="$HOME/.config/git/template"

TRAILERS=""

while true ; do
	pick="$(echo -e "$(git shortlog -e -s | cut -f2)" | fzy)"

	if [[ "$pick" != "" ]]; then
		TRAILERS+="Co-authored-by: $pick\n"
		echo "Added co-author: $pick"
	else
		break
	fi
done

if [[ "$TRAILERS" != "" ]] ; then
	echo -e "\n" > $TEMPLATE_PATH
	echo -e "$TRAILERS" >> $TEMPLATE_PATH

	echo "🧑‍💻Pairing mode enabled. Run 'git unpair' to end session."
fi
```

This uses Git's "commit template" feature to hack in the trailers for us
automatically on each commit. This requires you to have a bit of Git
configuration to point it at a template file:

```ini
[commit]
template = ~/.config/git/template
```

Unfortunately, as of 2.32 at least, template files _need to exist_ at all
times, even if they are empty. Make sure to touch it before proceeding to keep
Git happy.

As you may have noticed, we also will want `git-unpair` to end a pairing
session. This script is much simpler, however, as "ending a session" really
just means "emptying the commit template."

```bash
#!/usr/bin/env bash

set -euf -o pipefail

echo > "$HOME/.config/git/template"
echo "👋 Disabled pairing mode."
```

One quick other feature, however: what if you're pairing with someone who
doesn't have commits in the current repo? Well, we can supplement the commit
author list with a static list of "known colleagues" so that even in a blank
git repo we have a list of people to choose from.

```diff
TEMPLATE_PATH="$HOME/.config/git/template"

+if [[ -e "$HOME/.colleagues.txt" ]] ; then
+	COLLEAGUES="$(cat $HOME/.colleagues.txt)"
+else
+	COLLEAGUES=""
+fi

TRAILERS=""

while true ; do
-	pick="$(echo -e "$(git shortlog -e -s | cut -f2)" | fzy)"
+	pick="$(echo -e "$COLLEAGUES\n$(git shortlog -e -s | cut -f2)" | uniq | fzy)"

	if [[ "$pick" != "" ]]; then
```

Then you can automate or manually maintain `~/.colleagues.txt`, which should be
a plain text list of `Name &lt;email&gt;` lines. We pass everything through
`uniq` as well, to make sure any people in both lists only get one entry.

With all of that in place, you can now pair! It should be as easy as:

1. `git pair`
2. Fuzzy-select people (hit `^D` when done)
3. Make some commits
4. `git unpair`

Hopefully this makes your pairing sessions easier, with significantly less
awkward typing of trailers after every commit. The full source of the script,
and all my other scripts and configuration, are [in my dotfiles
repository][bin].

Happy pairing 🧑‍💻✨

[bin]: https://github.com/alexblackie/dotfiles/tree/e1c1136e8efb278d0a5a8493bf16376cb15e328a/configs/bin
