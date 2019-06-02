# 私

This is the source code that builds my website, [alexblackie.com][0].

It's a static site built with [Gatsby][1].

## Development

```
$ npm install
$ npx gatsby develop
```

## Production Builds

Building and production deployment is handled via Docker and (externally)
Kubernetes. The `Dockerfile` included should be everything required to build and
run the site.

```
$ docker build -t watashi .
$ docker run -p 8080:80 watashi
```

Or, to build manually:

```
$ npm install
$ npm run build
```

[0]: https://www.alexblackie.com/
[1]: https://www.gatsbyjs.org/
