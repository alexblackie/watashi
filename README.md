This is my humble slice of the internets.

I've taken an über-minimalist approach with this revision (dubbed v2.0, however
there have been many more before this). Everything is purposefully brutally
simple: static HTML (written by hand), a heavy two lines of CSS, and a Makefile
to compile it all.

## 0. Getting started
1. `git clone https://github.com/alexblackie/self.git`
2. `cd self`

## 1. Local development
1. `bin/server.sh` (may need to mark as executable first)
2. `open http://localhost:8000/`

## 2. Building for production
1. `make`

Everything is minified and put in `./build/`.
