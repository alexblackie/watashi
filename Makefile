ARTICLES=$(shell ls www/articles)

build:
	mkdir -p build/assets build/articles
	npm install minify
	minify www/index.html > build/index.html
	$(foreach article,$(ARTICLES),cat www/articles/$(article) | minify -html > build/articles/$(article);)
	cat www/assets/*.css | minify -css > build/assets/site.css
	cp -r www/assets/images build/assets/images/

clean:
	rm -rf build/
