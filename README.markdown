# 私

This is the source for my website, [alexblackie.com][0].

## Building

This site is constructed using a bespoke series of shell scripts (bash, sorry)
that parse and assemble all the content and pages.

The only dependencies are the GNU coreutils (`make`, `find`, `cat`, `bash`) and
Python's `pygmentize` CLI (usually available as `python-pygments` on Linuxes).

To compile the site:

```bash
$ make
```

The files will be placed in `./_build`.

To watch for changes, combine this with a tool such as [entr][1]:

```bash
$ ag -l | entr -cr make
```

## License

All source code is licensed under the MIT license (full text follows). The
content itself is not covered by this license.

```
Copyright 2019-2020 Alex Blackie

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

[0]: https://www.alexblackie.com
[1]: http://eradman.com/entrproject/
