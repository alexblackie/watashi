package main

import "github.com/gin-gonic/gin"

func main() {
	articleRepo := NewMemoryRepository("./articles", "/articles")
	if err := articleRepo.Preload(); err != nil {
		panic(err)
	}

	pageRepo := NewMemoryRepository("./pages", "/")
	if err := pageRepo.Preload(); err != nil {
		panic(err)
	}

	g := gin.Default()
	r := NewRouter(g, articleRepo, pageRepo)
	r.Configure()

	r.Listen(3000)
}
