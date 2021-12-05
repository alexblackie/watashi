# 私

This is the source for my website, [alexblackie.com][0].

## Building

This site is constructed using a bespoke series of shell scripts that parse and
assemble all the content and pages.

The only dependencies are the GNU/BSD coreutils (`make`, `find`, `cat`, `bash`)
and the [`chroma` CLI][1].

To compile the site:

```bash
$ make
```

The files will be placed in `./_build`.

To watch for changes, combine this with a tool such as [entr][2]:

```bash
$ find . -type f | entr make
```

## License

Written content (prose) is (C) Alex Blackie.

Computer source code is licensed under the GNU Affero General Public License,
the full text of which is available in [`LICENSE`](./LICENSE).

[0]: https://www.alexblackie.com
[1]: https://github.com/alecthomas/chroma
[2]: http://eradman.com/entrproject/
