package main

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"time"
)

func HelpersMap() template.FuncMap {
	h := &Helpers{}
	return template.FuncMap{
		"navHighlight": h.navHighlight,
		"icon":         h.icon,
		"permalink":    h.permalink,
		"humanDate":    h.humanDate,
		"rfc822Date":   h.rfc822Date,
	}
}

type Helpers struct {
}

func (h *Helpers) navHighlight(have, want string) string {
	if have == want {
		return "active"
	}
	return ""
}

func (h *Helpers) icon(name string) template.HTML {
	svg, err := ioutil.ReadFile(fmt.Sprintf("icons/%s.svg", name))
	if err != nil {
		return template.HTML("")
	}
	return template.HTML(svg)
}

func (h *Helpers) permalink(path string) string {
	return fmt.Sprintf("https://www.alexblackie.com%s", path)
}

func (h *Helpers) humanDate(t PublishDate) string {
	return t.Time.Format("January 2 2006")
}

func (h *Helpers) rfc822Date(t PublishDate) string {
	return t.Time.Format(time.RFC822)
}
