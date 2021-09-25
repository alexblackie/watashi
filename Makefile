articleSources=$(shell find articles -type f -name '*.html' -o -name '*.meta')
articleTargets=$(articleSources:articles/%/index.html=_build/articles/%/index.html)

pageSources=$(shell find pages -type f -name '*.html' -o -name '*.xml' -o -name '*.meta')
pageTargets=$(pageSources:pages/%.html=_build/%.html)
xmlPageTargets=$(pageSources:pages/%.xml=_build/%.xml)

staticSources=$(shell find static -type f)
staticTargets=$(staticSources:static/%=_build/%)

PATH := $(addprefix ./vendor/bin:,$(PATH))

all: vendor/bin/chroma $(articleTargets) $(staticTargets) $(pageTargets) $(xmlPageTargets)

vendor/bin/chroma:
ifeq (, $(shell which chroma))
	@# If the target system doesn't have chroma, download it since it's just a
	@# single static binary.
	@mkdir -p vendor/bin
	curl -qSsL "https://github.com/alecthomas/chroma/releases/download/v0.9.2/chroma-0.9.2-linux-amd64.tar.gz" | tar -xzC vendor/bin chroma
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
	rm -f vendor/bin/chroma

.PHONY: clean
