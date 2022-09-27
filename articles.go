package main

import (
	"errors"
	"fmt"
	"path/filepath"
	"sort"
	"time"
)

var articleCache = make(map[string]*Content)
var articleList []*DocumentMeta

func LoadArticles() error {
	files, _ := filepath.Glob("articles/*")
	for _, f := range files {
		content, err := GetContent(f, Assigns{})
		if err != nil {
			fmt.Printf("FAILED to parse content (%s): %v\n", f, err)
			continue
		}

		// fml
		baseSlug := filepath.Base(f)[:len(filepath.Base(f))-len(filepath.Ext(f))]
		content.Meta.Slug = "/articles/" + baseSlug + "/"

		articleCache[baseSlug] = content
		articleList = append(articleList, content.Meta)
	}
	sort.Slice(articleList, func(i, j int) bool {
		return articleList[i].PublishDate.Time.Unix() >
			articleList[j].PublishDate.Time.Unix()
	})
	return nil
}

func ListArticles(limit int) []*DocumentMeta {
	var max int
	if limit > len(articleCache) {
		max = len(articleCache)
	} else {
		max = limit
	}
	return articleList[:max]
}

func GetArticle(slug string) (*Content, error) {
	article := articleCache[slug]
	if article == nil {
		return nil, errors.New(fmt.Sprintf("Could not find article for slug! %v", slug))
	}
	return article, nil
}

func IsArticleOld(meta *DocumentMeta) bool {
	if meta.Evergreen {
		return false
	}
	return time.Now().Year()-meta.PublishDate.Time.Year() > 2
}
