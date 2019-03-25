# alexblackie dot com

this is my web page

i hope you like it

## Deployment

A `Dockerfile` is provided which builds a production-ready container image with
nginx to run the site, including SSI.

You could use it for development too.

```
$ docker build -t alexblackie.com:latest .
$ docker run --rm -p 8080:80 alexblackie.com
```
