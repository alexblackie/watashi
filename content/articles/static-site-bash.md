---
title: Generating Static Sites with Make and Bash
slug: static-site-bash
publishDate: "2019-06-16"
evergreen: true

open_graph_meta:
  title: Generating Static Sites with Make and Bash
  description: >
        You can get a pretty functional static site generator just using a bash
        script and some common Unix tools. Come see how.

---

When you think of `bash`, you may not consider it suitable for
building websites. For the most part, you are probably correct. But I
wanted to try anyway. I don't buy into most trends in the frontend web
development community, so literally none of the "modern" static site
generators appeal to me. All of them feel overcomplicated, too niche, or
too javascript-y for my needs, which involve _just rendering a
website_.

Inspired by [John Hawthorn's makefile website workflow](https://www.johnhawthorn.com/2018/01/this-website-is-a-makefile/)
I decided that was almost exactly what I wanted. However, I didn't really want
to depend on anything outside of standard unix tools (so no Ruby). This is
where bash comes in.

## "uhhh"

Look, hear me out. There are some reasons I actually ended up liking this:

* All the normal benefits of building static sites
* Really fast (sub-second full site builds on my laptop)
* No dependencies outside of GNU/POSIX tools
* It's kind of fun and weird
* i don't need to install 2500 npm packages and learn a cool new templating language that will be obsolete and unmaintained in 4 months

Ultimately, this was just a fun project to make my personal site a little more
interesting. This really isn't something that is overly practical. Nothing
wrong with a little fun now and then, though!

## The result

Before we get in the weeds, let's see what the end-goal for project structure
is. I've removed a few things that are in my own site, just to keep this
example simple.

```
.
├── _build/
│   └── ...
├── bin/
│   └── render*
├── layouts/
│   └── site.html
├── pages/
│   ├── some-page/
│   │   ├── index.html
│   │   └── index.meta
│   ├── index.html
│   └── index.meta
├── static/
│   ├── _/
│   │   └── site.css
│   └── favicon.ico
├── Makefile
└── helpers.sh
```

Basically, we have a directory for pages (`./pages`) and then one directory for
each page, with a `.meta` file for metadata (title, variables, etc) and a
`.html` file for the content itself.

## Setting up `make`

Originally, I had started with pure bash -- just a single bash script that
handled the entire pipeline from finding the files, to parsing them, to writing
to a file. This actually worked out great, but was missing some niceties like
incremental builds, and meant a lot of it was sort of "intertwined" where
rendering a page had weird knowledge about where that page should be written to
disk.

So ultimately I decided simplifying the shell script to just render a page to
`stdout` and let good ol&rsquo; `make` handle the reading and writing seemed
like a more robust option.

Luckily, because we're just running one command and writing that to disk,
our Makefile can be pretty simple:

```makefile
# Find all html and meta files in the pages directory
pageSources=$(shell find pages -type f -name '*.html' -o -name '*.meta')

# Map all the html files in the list of sources to the target path in _build
pageTargets=$(pageSources:pages/%.html=_build/%.html)

all: $(pageTargets)

_build/%.html: pages/%.html pages/%.meta
    @# Silently (@) make all directories leading up to our target file ($@)
    @mkdir -p $(dir $@)

    @# Run our render script, giving the source file name ($<), substring-
    @# replacing "html" with "meta" (as our script expects to be given
    @# the meta file). Write the output to the target filename ($@)
    bin/render $(<:html=meta) &gt; $@

clean:
    rm -rf _build/*
```

All this does is find all `*.meta` and `*.html` files, and tell `make` that
those should turn into a single HTML file in `_build`, by running the
`bin/render` script. Of course, a lot of this is terse or a bit weird to read
if you're unfamiliar with Makefiles, but in the end it is rather simple, and
provides some pretty significant power for not a lot of code.

## Proof of concept: straight renders

To prove that this might actually work, the first thing to get going is a just
rendering the page HTML itself, with basic variable substitution for things
like page title, etc., but without a layout or any fancy stuff.

The general idea here is to parse our template files inside a Here Document,
which will give them full access to shell functions, local variables, and any
command they want, really. This is obviously a huge security risk, but there
should never be untrusted code being executed in this context, so the realistic
risk is pretty minimal.

```bash
# bin/render

#!/usr/bin/env bash

set -euf -o pipefail

render() {
    title="My web page"
    echo "$(eval "cat <<EOF
        $(<${1/.meta/.html})
EOF")"
}

render $@
```

In essence, what we're doing here is reading an HTML file in as a string,
which is interpolated into a heredoc, which is piped into `cat`,
which is in a string, which we are evaluating as if it were a script
itself. This means that the normal variable scope and expansion applies to
our template.

The `index.html` source file, for reference:

```html
<!-- pages/index.html -->
<h1>$title</h1>
```

And that's honestly about it. Everything else from here is just doing this
multiple times, or adding some sugar or abstractions. Speaking of, let's
make this nicer.

## Adding a layout

Currently we're just copying one file around, which isn't really helpful
for a static site builder! What really made this "click" was getting a
layout template wrapping the pages -- the most basic feature of any static
site generator.

So let's do that. All this is really doing is assigning the page to a
variable, then rendering the layout as if it was the page.

```bash
# bin/render

#!/usr/bin/env bash

set -euf -o pipefail

render() {
    title="My web page"
<span class="code-rem">    echo "$(eval "cat &lt;&lt;EOF</span>
<span class="code-add">    content="$(eval "cat &lt;&lt;EOF</span>
        $(&lt;${1/.meta/.html})
EOF")"

<span class="code-add">    echo "$(eval "cat &lt;&lt;-EOF</span>
<span class="code-add">        $(&lt;layouts/site.html)</span>
<span class="code-add">    EOF")"</span>
}

render $@
```

In our layout, we can then just use `$content` where we want to
render the page content.

```html
<!-- layouts/site.html -->
<!doctype html>
<title>$title</title>
$content
```

We're getting pretty close to something useful. But hard-coding all our
metadata in the build script doesn't scale. Let's fix that.


## Metadata is just scripts

Previously I had mentioned `.meta` files, but up until now we haven't used
them.  Since our pages are being rendered within the context of the bash
script, we can source other scripts in dynamically. So, our `.meta` files are
just little bash scripts that are evaluated right before render. Thus, they
could contain variables, functions, calls to external APIs or programs&hellip;

Here's the `.meta` file for our page:

```bash
# page/index.meta
title="My web page"
lastUpdatedAt="2019-06-13"
```

And in the build script, all we need to do is source our `.meta` file
dynamically, as we do with the HTML template. Since our render script is being
given the meta file as the first argument, we can just source that:

```bash
# bin/render
...
render() {
<span class="code-rem">    title="My web page"</span>
<span class="code-add">    . "$1"</span>
    content=$(eval "cat &lt;&lt;EOF
        $(&lt;${1/.meta/.html})
EOF")
...
```

Another "lightbulb" moment is when you start to add shell functions. Want
to format a date? Good news! Basically every computer probably already has
`date(1)`

We can just add more functions to the `bin/render` file, or if we have a lot we
can source a second file into it... It's just a shell script, so I mean you can
do whatever you want.

```bash
# bin/render

#!/usr/bin/env bash

set -euf -o pipefail

<span class="code-add">formatDate() {</span>
<span class="code-add">    echo $(date -d "$1" +"%B %-d %Y")</span>
<span class="code-add">}</span>

render() {
...
```

```html
<!-- pages/index.html -->

<h1>$title</h1>
Last updated: $(formatDate $lastUpdatedAt)
```

That's it. Now we can use ISO-8601 dates in our metadata, but still display
"human" dates on the site itself.

You can even combine it with Here Documents to make more complex render
helper functions. I do this on my site to dynamically discover blog
articles from the filesystem, parse and sort them based on their date in
metadata, and then render a provided template string with the new local
variables. It's a bit convoluted and gross to use as a direct example, so
here's a simplified one:

```bash
# build.sh
...

renderItems() {
    items=(one two three)
    template="$(while read template ; do echo $template ; done)"

    for item in ${items[*]} ; do
        eval "cat <<-EOFOR
            $template
        EOFOR"
    done
}

...
```

```bash
# pages/index.html
...

<ul>
$(renderItems <<-EOTEMPLATE
    <li>$item</li>
EOTEMPLATE
)
</ul>
```

At this point, that's basically 90% of a static site generator. You got
layouts, templates, and metadata variables with support for helper
functions, extenal "plugins" (normal CLI tools)&hellip; What more do you
need?

## Assets

Every site will have some CSS, JS, images, and whatever else. You could
call out to some preprocessor or crazy thing if you really wanted, but for
me I am happy with raw CSS and JS, so here is my asset pipeline:

```diff
+staticSources=$(shell find static -type f)
+staticTargets=$(staticSources:static/%=_build/%)

-all: $(pageTargets)
+all: $(pageTargets) $(staticTargets)

...

+_build/%: static/%
+    @mkdir -p $(dir $@)
+    cp $< $@

...
```

🖌👌✨

## What's the catch?

While the core idea proved to work out great, it was not without rough
edges. In the end, these all proved fine to work around or put up with, but
they exist nonetheless.

- **Escaping normal content** -- since every page is parsed as a string, you
  need to be careful what that string contains. For example, "`I paid $50`"
  needs to be "`I paid \$50`" to avoid ``$5`` being parsed as a
  variable.
- **Shell scripts kind of suck** -- shell scripting is not really a pleasant
  environment. Decades of weird decisions, cumbersome syntax... While shell
  scripts get you a powerful and highly extensible environment, that comes at a
  cost of some readability and "niceness" that you might expect from something
  like ERB or Handlebars, for example.
- **Cross-OS compatibility is a nightmare** &mdash; you'd think POSIX meant
  everything behaves the same but HA-HA NOPE good luck maintaining weird `if`
  statements to try and make sure you pass different flags to GNU vs. BSD
  `date` or `find` to support both platforms.

## Also I left out a bunch of other stuff

I have left out a significant amount of work and numerous features that are
implemented in the "real" version of this script that powers my site. You are
free to [peruse my website's source code](https://github.com/alexblackie/watashi/tree/bf8552453defdcc92d1ba07a5c14f0bc79cea408),
if you are curious. This post was intended not to be a guide or tutorial but
just a neat showcase of a semi-crazy idea.

In brief, some features that were pretty easy to add that my script ended
up supporting:

* custom layouts per page
* nested layouts for articles
* xml pages and layouts (rss feed)
* dynamically building list of articles from filesystem

---

This was a fun project for me, and the end result solved a real need.
Hopefully it was as interesting to you as it was me!
