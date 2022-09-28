package main

import "testing"

func TestMemoryRepositoryFind(t *testing.T) {
	r := NewMemoryRepository("testing/articles", "articles")
	if err := r.Preload(); err != nil {
		t.Fatalf("Failed to preload test articles: %v", err)
	}

	a, err := r.Find("some-article")

	if err != nil {
		t.Fatalf("Could not find article! %v", err)
	}

	if a.Meta.Title != "Some Test Article" {
		t.Fatalf("Found article but had unexpected title: %v", a.Meta.Title)
	}
}

func TestMemoryRepositoryLatest(t *testing.T) {
	r := NewMemoryRepository("testing/articles", "articles")
	if err := r.Preload(); err != nil {
		t.Fatalf("Failed to preload test articles: %v", err)
	}

	result := r.Latest(3)

	if len(result) != 3 {
		t.Fatalf("Latest(3) returned wrong number of articles: %v", len(result))
	}

	if result[0].Meta.PublishDate.Time.Before(result[1].Meta.PublishDate.Time) {
		t.Fatalf("Latest() returned articles in the wrong order!")
	}
}

func TestMemoryRepositoryLatestWithExcessiveLimit(t *testing.T) {
	r := NewMemoryRepository("testing/articles", "articles")
	if err := r.Preload(); err != nil {
		t.Fatalf("Failed to preload test articles: %v", err)
	}

	result := r.Latest(10000000)

	if len(result) != 4 {
		t.Fatalf("Latest() should have returned five but instead: %v", len(result))
	}
}
