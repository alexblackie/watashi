package main

import (
	"flag"

	"github.com/gin-gonic/gin"
)

var (
	port        = flag.Int("port", 3000, "Set the web server listening port.")
	articlePath = flag.String("articles", "./articles", "Path to the directory containing the article documents.")
	pagePath    = flag.String("pages", "./pages", "Path to the directory containing the page documents.")
)

func main() {
	flag.Parse()

	articleRepo := NewMemoryRepository(*articlePath, "/articles")
	if err := articleRepo.Preload(); err != nil {
		panic(err)
	}

	pageRepo := NewMemoryRepository(*pagePath, "/")
	if err := pageRepo.Preload(); err != nil {
		panic(err)
	}

	g := gin.Default()
	r := NewRouter(g, articleRepo, pageRepo)
	r.Configure()

	r.Listen(*port)
}
