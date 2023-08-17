# 私

`watashi` runs [alexblackie.com].

It's an [Elixir] application, using [Plug] for routing and [Bandit] for HTTP
serving. All content is stored in-repo and parsed on application boot.

[alexblackie.com]: https://www.alexblackie.com
[Elixir]: https://www.elixir-lang.org
[Plug]: https://github.com/elixir-plug/plug
[Bandit]: https://github.com/mtrudel/bandit

## Running

This application is released exclusively as a container image for deployment.

```
$ docker run --rm -it -p 4000:4000 ghcr.io/alexblackie/watashi
```

## Development

First, copy the example runtime configuration in place, and edit if desired:

```
$ cp config/runtime.exs.example config/runtime.exs
```

Then, fetch all dependencies:

```
$ mix deps.get
```

Then you can run a development server in an `iex` shell:

```
$ iex -S mix
```

Or run the test suite:

```
$ mix test
```

## License

Written content is (C) Alex Blackie. No reuse or distribution is authorized
without explicit consent.

Source code license terms are available in [LICENSE](./LICENSE).
