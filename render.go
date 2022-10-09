package main

import (
	"bytes"
	"errors"
	"fmt"
	"html/template"
	"path/filepath"
	textTemplate "text/template"

	"github.com/Depado/bfchroma/v2"
	chromaHTML "github.com/alecthomas/chroma/v2/formatters/html"
	"github.com/russross/blackfriday/v2"
)

// Assigns is a freeform map that will be passed to the template when rendering
// the content.
type Assigns map[string]interface{}

// RenderContext is a combination of all the various data required to render a
// template, wrapping the metadata and any custom assigns.
type RenderContext struct {
	Config   *Config
	Document *Document
	Assigns  *Assigns
}

// RenderResult wraps the input Document and the parsed and rendered output
// string (not HTML safe).
type RenderResult struct {
	Output   string
	Document *Document
}

func Render(doc *Document, assigns Assigns, config *Config) (*RenderResult, error) {
	ctx := &RenderContext{Config: config, Document: doc, Assigns: &assigns}
	content, err := ParseContent(doc.Meta.Type, ctx)
	if err != nil {
		return nil, err
	}
	return &RenderResult{Document: doc, Output: content}, nil
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
		Funcs(HelpersMap(ctx.Config)).
		Parse(ctx.Document.Raw)

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
		Funcs(HelpersMap(ctx.Config)).
		Parse(ctx.Document.Raw)

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
	out := blackfriday.Run([]byte(ctx.Document.Raw), blackfriday.WithRenderer(
		bfchroma.NewRenderer(
			bfchroma.Style("github"),
			bfchroma.ChromaOptions(chromaHTML.WithClasses(true)),
		),
	))
	return string(out), nil
}
