package main

import (
	"io/ioutil"
	"testing"

	"gopkg.in/yaml.v3"
)

func TestDocumentMetaUnmarshalYAML(t *testing.T) {
	var doc DocumentMeta
	raw, err := ioutil.ReadFile("testing/example_document_meta.yaml")
	if err != nil {
		t.Fatalf("Could not read test publish date meta: %v", err)
	}
	err = yaml.Unmarshal(raw, &doc)
	if err != nil {
		t.Fatalf("Could not unmarshal publish date meta: %v", err)
	}

	if doc.PublishDate.Time.Unix() != 1665100800 {
		t.Fatalf("PublishDate unmarshaled wrong date! Got: %v", doc.PublishDate.Time.Unix())
	}
	if doc.LastUpdateDate.Time.Unix() != 1665187200 {
		t.Fatalf("LastUpdateDate unmarshaled wrong date! Got: %v", doc.LastUpdateDate.Time.Unix())
	}

	if doc.Title != "Some Example Content" {
		t.Fatalf("Title was incorrectly unmarshaled: %v", doc.Title)
	}
	if doc.OpenGraphTitle != "Some Example Content for the Internet" {
		t.Fatalf("OpenGraphTitle was incorrectly unmarshaled: %v", doc.OpenGraphTitle)
	}
	if doc.OpenGraphImageURL != "og-cover.jpg" {
		t.Fatalf("OpenGraphImageURL was incorrectly unmarshaled: %v", doc.OpenGraphImageURL)
	}
	if doc.OpenGraphDescription != "Read this content." {
		t.Fatalf("OpenGraphDescription was incorrectly unmarshaled: %v", doc.OpenGraphDescription)
	}
	if doc.Slug != "some-example-content" {
		t.Fatalf("Slug was incorrectly unmarshaled: %v", doc.Slug)
	}
	if doc.CoverURL != "cover.jpg" {
		t.Fatalf("CoverURL was incorrectly unmarshaled: %v", doc.CoverURL)
	}
	if doc.CoverWidth != 600 {
		t.Fatalf("CoverWidth was incorrectly unmarshaled: %v", doc.CoverWidth)
	}
	if doc.CoverHeight != 400 {
		t.Fatalf("CoverHeight was incorrectly unmarshaled: %v", doc.CoverHeight)
	}
	if doc.CoverAlt != "A blank image." {
		t.Fatalf("CoverAlt was incorrectly unmarshaled: %v", doc.CoverAlt)
	}

	if doc.Evergreen != false {
		t.Fatal("Evergreen defaulted to true, but should be false")
	}
}
