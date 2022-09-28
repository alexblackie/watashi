package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"net/url"
	"os"
	"path"
	"path/filepath"
	"sort"
	"strings"

	"gopkg.in/yaml.v3"
)

// IRepository defines the interface for a "content repository" which holds the
// raw documents -- this is generally a filesystem or database.
type IRepository interface {
	Latest(int) []*Document
	Find(string) (*Document, error)
}

// MemoryRepository is an implementation of `IRepository` that reads content
// from disk and caches it in memory.
type MemoryRepository struct {
	Root       string
	SlugPrefix string
	cache      map[string]*Document
}

func (r *MemoryRepository) Preload() error {
	files, _ := filepath.Glob(path.Join(r.Root, "*"))
	for _, f := range files {
		if stat, _ := os.Stat(f); stat.IsDir() {
			continue
		}
		fileType := filepath.Ext(f)
		// fml
		slug := filepath.Base(f)[:len(filepath.Base(f))-len(fileType)]

		data, err := ioutil.ReadFile(f)
		if err != nil {
			return err
		}

		rawMeta, rawContent, hasMeta := strings.Cut(string(data), MetadataSeparator)
		if !hasMeta {
			fmt.Printf("Couldn't parse meta in content: \n%v\n", string(rawContent))
			r.cache[slug] = &Document{Meta: new(DocumentMeta), Raw: rawContent}
			continue
		}

		var meta *DocumentMeta
		err = yaml.Unmarshal([]byte(rawMeta), &meta)
		if err != nil {
			return err
		}
		meta.Type = fileType
		if slug == "index" {
			meta.Slug, _ = url.JoinPath(r.SlugPrefix, "/")
		} else {
			meta.Slug, _ = url.JoinPath(r.SlugPrefix, slug, "/")
		}

		r.cache[slug] = &Document{
			Meta: meta,
			Raw:  rawContent,
		}
	}
	return nil
}

func (r *MemoryRepository) Latest(limit int) []*Document {
	var result []*Document
	for _, doc := range r.cache {
		result = append(result, doc)
	}
	sort.Slice(result, func(i, j int) bool {
		return result[i].Meta.PublishDate.Time.After(result[j].Meta.PublishDate.Time)
	})
	if limit > len(result) {
		limit = len(result)
	}
	return result[:limit]
}

func (r *MemoryRepository) Find(slug string) (*Document, error) {
	result := r.cache[slug]
	if result == nil {
		return nil, errors.New(fmt.Sprintf("Count not find page with slug: %v", slug))
	}
	return result, nil
}

func NewMemoryRepository(root string, slugPrefix string) *MemoryRepository {
	return &MemoryRepository{
		Root:       root,
		SlugPrefix: slugPrefix,
		cache:      make(map[string]*Document),
	}
}
