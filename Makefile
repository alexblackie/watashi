HTMLFILES=www/index.html $(wildcard www/articles/*.html)
TXTFILES=$(wildcard www/*.html)
CSSFILES=$(wildcard www/assets/*.css)
HTMLTARGETS=$(HTMLFILES:www/%.html=build/%.html)

all: build

node_modules:
	npm install minify

build/assets/site.css: $(CSSFILES) node_modules
	@mkdir -p $(dir $@)
	cat $(CSSFILES) | node_modules/.bin/minify -css > $@

build/%.html: www/%.html ga.txt node_modules
	@mkdir -p $(dir $@)
	cat $< ga.txt | node_modules/.bin/minify -html > $@

build: build/assets/site.css $(HTMLTARGETS)

clean:
	rm -Rf build/ node_modules

server:
	@pushd www/; python -m SimpleHTTPServer 8000; popd;

.PHONY: all build clean deps
