# 私

[![Test Suite](https://github.com/alexblackie/watashi/actions/workflows/test.yaml/badge.svg)](https://github.com/alexblackie/watashi/actions/workflows/test.yaml)

`watashi` is the software that runs my website, [alexblackie.com](https://www.alexblackie.com).

## Highlights

- It's built to be a server-side rendered [Rust](https://www.rust-lang.org) web application.
- Content is a mix of HTML and Markdown.
- Content is "discovered" on the disk and pre-rendered when the program starts.
- Most content is cached in memory for optimal performance.

## Building

Ensure you have the latest `stable` release of the Rust toolchain installed. There is no mandatory configuration or setup; you can immediately download all dependencies, compile, and run the web server with:

```
$ cargo run
```

You can also run the test suite:

```
$ cargo test
```

## License

Written content (prose) is (C) Alex Blackie.

Computer source code is licensed under the GNU Affero General Public License, the full text of which is available in [`LICENSE`](./LICENSE).
