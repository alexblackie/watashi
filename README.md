# alexblackie.com - Retro Edition 2015

This redesign of my website is codenamed "Retro Edition 2015" for a reason: it's
time to go way back and pretend it's 2001 all over again. Time for XHTML, raw
and minimal CSS, default browser styles, SSI for templating...

## Building

Contrary to the theme of the rest of the site, a`Dockerfile` is included. For a
local dev server (for SSI), simply:

1. `docker build -t self-nginx .`
2. `docker run -it --rm -v `pwd`:/srv/www -p 8080:80 self-nginx`
3. `xdg-open http://localhost:8080/`
