articleSources=$(shell find articles -type f -name '*.html' -o -name '*.meta')
articleTargets=$(articleSources:articles/%/index.html=_build/articles/%/index.html)

pageSources=$(shell find pages -type f -name '*.html' -o -name '*.xml' -o -name '*.meta')
pageTargets=$(pageSources:pages/%.html=_build/%.html)
xmlPageTargets=$(pageSources:pages/%.xml=_build/%.xml)

staticSources=$(shell find static -type f)
staticTargets=$(staticSources:static/%=_build/%)

all: check $(articleTargets) $(staticTargets) $(pageTargets) $(xmlPageTargets)

check:
ifeq (, $(shell which chroma))
	$(error The chroma CLI must be installed. See github.com/alecthomas/chroma)
endif
	@true

_build/articles/%/index.html: articles/%/index.html articles/%/index.meta layouts/site.html layouts/article.html
	@mkdir -p $(dir $@)
	bin/render $(<:html=meta) article > $@

_build/%.xml: pages/%.xml
	@mkdir -p $(dir $@)
	bin/render $(<:xml=meta) > $@

_build/%.html: pages/%.html pages/%.meta layouts/site.html
	@mkdir -p $(dir $@)
	bin/render $(<:html=meta) > $@

_build/_/site.css: static/_/site.css
	@mkdir -p $(dir $@)
	@# minify css by stripping tabs, newlines, and some spaces, separators, etc.
	tr -d '\n\t' < $< | sed 's/;}/}/g; s/: /:/g; s/, /,/g; s/ {/{/g' > $@

_build/%: static/%
	@mkdir -p $(dir $@)
	cp $< $@

clean:
	rm -rf _build/*

.PHONY: clean check
