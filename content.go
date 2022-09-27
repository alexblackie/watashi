package main

import (
	"bytes"
	"errors"
	"fmt"
	"html/template"
	"io/ioutil"
	"path/filepath"
	"strings"
	textTemplate "text/template"
	"time"

	"github.com/Depado/bfchroma/v2"
	chromaHTML "github.com/alecthomas/chroma/v2/formatters/html"
	"github.com/russross/blackfriday/v2"
	"gopkg.in/yaml.v3"
)

// MetadataSeparator is the phrase that will deliniate the metadata from the
// content in a document. We will split on the first instance of this string
// and consider everything after it part of the content, and everything before
// it part of the meta.
const MetadataSeparator = "---\n"

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
	Title          string       `yaml:"title"`
	Slug           string       `yaml:"slug"`
	Nav            string       `yaml:"nav"`
	PublishDate    *PublishDate `yaml:"publishDate"`
	LastUpdateDate *PublishDate `yaml:"lastUpdateDate"`
	Evergreen      bool         `yaml:"evergreen"`

	OpenGraphTitle       string `yaml:"openGraphTitle"`
	OpenGraphImageURL    string `yaml:"openGraphImageUrl"`
	OpenGraphDescription string `yaml:"openGraphDescription"`

	CoverURL    string `yaml:"coverUrl"`
	CoverAlt    string `yaml:"coverAlt"`
	CoverWidth  int    `yaml:"coverWidth"`
	CoverHeight int    `yaml:"coverHeight"`
}

// Content is a container that represents a single piece of content in the
// site. It holds both the unmarshaled metadata as well as the raw content.
type Content struct {
	// Meta is a genericised struct that holds the meta information about this
	// content (title, slug, etc.).
	Meta *DocumentMeta

	// Raw holds the un-parsed content itself. This could be markdown, an HTML
	// template, or any other "raw" content.
	Raw *string

	// Parsed is the compiled and executed output of the template, but is not
	// HTML safe. See `HTML()`.
	Parsed *string
}

func (c *Content) HTML() template.HTML {
	return template.HTML(*c.Parsed)
}

// Assigns is a freeform map that will be passed to the template when rendering
// the content.
type Assigns map[string]interface{}

// RenderContext is a combination of all the various data required to render a
// template, wrapping the metadata and any custom assigns.
type RenderContext struct {
	Content *Content
	Assigns *Assigns
}

func GetContent(p string, assigns Assigns) (*Content, error) {
	data, err := ioutil.ReadFile(p)
	if err != nil {
		return nil, err
	}

	rawMeta, rawContent, hasMeta := strings.Cut(string(data), MetadataSeparator)
	if !hasMeta {
		fmt.Printf("Couldn't parse meta in content: \n%v\n", string(data))
		return &Content{Meta: new(DocumentMeta), Raw: &rawContent}, nil
	}

	var meta *DocumentMeta
	err = yaml.Unmarshal([]byte(rawMeta), &meta)
	if err != nil {
		return nil, err
	}

	content := &Content{
		Meta: meta,
		Raw:  &rawContent,
	}

	contentHTML, err := ParseContent(p, &RenderContext{Content: content, Assigns: &assigns})
	if err != nil {
		return nil, err
	}
	content.Parsed = &contentHTML

	return content, nil
}

func ParseContent(path string, ctx *RenderContext) (string, error) {
	ext := filepath.Ext(path)
	switch ext {
	case ".html":
		return parseHTMLContent(ctx)
	case ".xml":
		return parseXMLContent(ctx)
	case ".md":
		return parseMarkdownContent(ctx)
	default:
		return "", errors.New(fmt.Sprintf("Unsupported extension: %v!\n", ext))
	}
}

func parseHTMLContent(ctx *RenderContext) (string, error) {
	var out bytes.Buffer
	tmpl, err := template.
		New("content").
		Funcs(HelpersMap()).
		Parse(*ctx.Content.Raw)

	if err != nil {
		return "", err
	}
	err = tmpl.Execute(&out, ctx)
	if err != nil {
		return "", err
	}
	return out.String(), nil
}

func parseXMLContent(ctx *RenderContext) (string, error) {
	var out bytes.Buffer
	tmpl, err := textTemplate.
		New("content").
		Funcs(HelpersMap()).
		Parse(*ctx.Content.Raw)

	if err != nil {
		return "", err
	}
	err = tmpl.Execute(&out, ctx)
	if err != nil {
		return "", err
	}
	return out.String(), nil
}

func parseMarkdownContent(ctx *RenderContext) (string, error) {
	out := blackfriday.Run([]byte(*ctx.Content.Raw), blackfriday.WithRenderer(
		bfchroma.NewRenderer(
			bfchroma.Style("github"),
			bfchroma.ChromaOptions(chromaHTML.WithClasses(true)),
		),
	))
	return string(out), nil
}
