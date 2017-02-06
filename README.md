# alexblackie.com - Retro Edition 2015

This redesign of my website is codenamed "Retro Edition 2015" for a reason: it's
time to go way back and pretend it's 2001 all over again. Time for XHTML, raw
and minimal CSS, default browser styles, SSI for templating...

## Running Locally

### Manually

If you have `nginx` installed already, you can just run the included development
configuration yourself:

```
$ nginx -c nginx.dev.conf -p .
```

You may need to edit the location of `mime.types` depending on where your system
version of nginx is installed.

### With Docker

Contrary to the theme of the rest of the site, a Dockerfile is included. For
a local dev server (for SSI), simply:

1. `docker build -f Dockerfile.dev -t self-dev .`
2. `docker run -it --rm -v `pwd`:/srv/www -p 8080:80 self-dev`
3. `xdg-open http://localhost:8080/`
