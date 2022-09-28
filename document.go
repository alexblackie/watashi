package main

import (
	"html/template"
	"strings"
	"time"
)

// MetadataSeparator is the phrase that will deliniate the metadata from the
// content in a document. We will split on the first instance of this string
// and consider everything after it part of the content, and everything before
// it part of the meta.
const MetadataSeparator = "---\n"

// PublishDate wraps a `time.Time` so that we can deserialize ISO-8601
// timestamps from YAML into it.
type PublishDate struct {
	Time time.Time
}

func (d *PublishDate) UnmarshalYAML(call func(interface{}) error) error {
	var datestring string
	if err := call(&datestring); err != nil {
		return err
	}
	date, err := time.Parse("2006-01-02", strings.TrimSpace(datestring))
	if err != nil {
		return err
	}
	d.Time = date
	return nil
}

// DocumentMeta represents the maximal set of metadata you could attribute to a
// piece of content.
type DocumentMeta struct {
	Type      string
	Title     string `yaml:"title"`
	Slug      string `yaml:"slug"`
	Nav       string `yaml:"nav"`
	Evergreen bool   `yaml:"evergreen"`

	PublishDate    *PublishDate `yaml:"publishDate"`
	LastUpdateDate *PublishDate `yaml:"lastUpdateDate"`

	OpenGraphTitle       string `yaml:"openGraphTitle"`
	OpenGraphImageURL    string `yaml:"openGraphImageUrl"`
	OpenGraphDescription string `yaml:"openGraphDescription"`

	CoverURL    string `yaml:"coverUrl"`
	CoverAlt    string `yaml:"coverAlt"`
	CoverWidth  int    `yaml:"coverWidth"`
	CoverHeight int    `yaml:"coverHeight"`
}

// Document is a container that represents a single piece of content in the
// site. It holds both the unmarshaled metadata as well as the raw content.
type Document struct {
	// Meta is a genericised struct that holds the meta information about this
	// content (title, slug, etc.).
	Meta *DocumentMeta

	// Raw holds the un-parsed content itself. This could be markdown, an HTML
	// template, or any other "raw" content.
	Raw string

	// Parsed is the compiled and executed output of the template, but is not
	// HTML safe. See `HTML()`.
	Parsed string
}

func (d *Document) HTML() template.HTML {
	return template.HTML(d.Parsed)
}
