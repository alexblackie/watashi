ARTICLES=$(shell ls www/articles)

build:
	mkdir -p build/assets build/articles
	npm install minify
	node_modules/.bin/minify www/index.html > build/index.html
	$(foreach article,$(ARTICLES),cat www/articles/$(article) ga.txt | node_modules/.bin/minify -html > build/articles/$(article);)
	cat www/assets/*.css | node_modules/.bin/minify -css > build/assets/site.css
	cp -r www/assets/images build/assets
	cat ga.txt >> build/index.html

clean:
	rm -rf build/
	rm -rf node_modules
