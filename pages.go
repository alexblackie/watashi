package main

import (
	"fmt"
)

func GetPage(slug string, assigns Assigns) (*Content, error) {
	return GetContent(fmt.Sprintf("pages/%s", slug), assigns)
}
