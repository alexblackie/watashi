package main

import (
	"strings"
	"testing"
	"time"
)

func TestHelpersIcon(t *testing.T) {
	h := &Helpers{}
	result := h.icon("truck")
	if !strings.HasPrefix(string(result), "<svg xmlns=") {
		t.Fatalf("Icon helper did not return svg! Got %v", result)
	}
}

func TestHelpersNavHighlight(t *testing.T) {
	h := &Helpers{}
	active := h.navHighlight("one", "one")
	if active != "active" {
		t.Fatalf("navHighlight should have been active, but was: %v", active)
	}
	inactive := h.navHighlight("one", "articles")
	if inactive != "" {
		t.Fatalf("navHighlight should have been inactive but was: %v", inactive)
	}
}

func TestHelpersPermalink(t *testing.T) {
	config := NewDefaultConfig()
	h := &Helpers{Config: config}
	result := h.permalink("/articles")
	if result != "https://www.alexblackie.com/articles" {
		t.Fatalf("Permalink returned unexpected string: %v", result)
	}
}

func TestHelpersHumanDate(t *testing.T) {
	h := &Helpers{}
	ts, err := time.Parse("2006-01-02", "2022-10-07")
	if err != nil {
		t.Fatalf("Time parsing failed? %v", err)
	}
	result := h.humanDate(PublishDate{Time: ts})
	if result != "October 7 2022" {
		t.Fatalf("HumanDate incorrectly humanized date: %v", result)
	}
}

func TestHelpersRFCDate(t *testing.T) {
	h := &Helpers{}
	ts, err := time.Parse("2006-01-02", "2022-10-07")
	if err != nil {
		t.Fatalf("Time parsing failed? %v", err)
	}
	result := h.rfcDate(PublishDate{Time: ts})
	if result != "Fri, 07 Oct 2022 00:00:00 +0000" {
		t.Fatalf("rfcDate incorrectly formatted date: %v", result)
	}
}

func TestHelpersIsOld(t *testing.T) {
	h := &Helpers{}
	meta := &DocumentMeta{PublishDate: &PublishDate{Time: time.Now()}}
	if h.isOld(meta) {
		t.Fatalf("isOld incorrectly said that now is old!")
	}

	oldMeta := &DocumentMeta{PublishDate: &PublishDate{Time: time.Now().Add(-26298 * time.Hour)}}
	if !h.isOld(oldMeta) {
		t.Fatalf("isOld incorrectly said that 3 years ago isn't old!")
	}
}
