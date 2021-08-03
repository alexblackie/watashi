# 私

This is the source for my website, [alexblackie.com][0].

## Building

This site is constructed using a bespoke series of shell scripts (bash, sorry)
that parse and assemble all the content and pages.

The only dependencies are the GNU coreutils (`make`, `find`, `cat`, `bash`) and
the [`chroma` CLI][1].

To compile the site:

```bash
$ make
```

The files will be placed in `./_build`.

To watch for changes, combine this with a tool such as [entr][2]:

```bash
$ find . -type f | entr make
```

### Docker-based development

If you are on a non-GNU operation system such as macOS, or simply don't want to
bother with setup, a development-focused Dockerfile is provided as an easy way
to get a dev server running quickly.

To build and run the container, simply use the binstub:

```
$ bin/dev
```

This will start both a web server (on port 3000), and a file watcher to
recompile changes automatically.

You can control the port with `$PORT` and the tag of the local container image
with `$WATASHI_TAG`.

## License

Written content (prose) is (C) Alex Blackie.

Computer source code is licensed under the GNU Affero General Public License,
the full text of which is available in [`LICENSE`](./LICENSE).

[0]: https://www.alexblackie.com
[1]: https://github.com/alecthomas/chroma
[2]: http://eradman.com/entrproject/
