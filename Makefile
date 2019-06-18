articleSources=$(shell find articles -type f -name '*.html' -o -name '*.meta')
articleTargets=$(articleSources:articles/%/index.html=_build/articles/%/index.html)

pageSources=$(shell find pages -type f -name '*.html' -o -name '*.xml' -o -name '*.meta')
pageTargets=$(pageSources:pages/%.html=_build/%.html)
xmlPageTargets=$(pageSources:pages/%.xml=_build/%.xml)

staticSources=$(shell find static -type f)
staticTargets=$(staticSources:static/%=_build/%)


all: $(articleTargets) $(staticTargets) $(pageTargets) $(xmlPageTargets)

_build/articles/%/index.html: articles/%/index.html articles/%/index.meta layouts/site.html
	@mkdir -p $(dir $@)
	bin/render $(<:html=meta) article > $@

_build/%.xml: pages/%.xml
	@mkdir -p $(dir $@)
	bin/render $(<:xml=meta) > $@

_build/%.html: pages/%.html pages/%.meta layouts/site.html
	@mkdir -p $(dir $@)
	bin/render $(<:html=meta) > $@

_build/%: static/%
	@mkdir -p $(dir $@)
	cp $< $@

clean:
	rm -rf _build/*

.PHONY: clean
