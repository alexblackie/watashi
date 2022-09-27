package main

import "github.com/gin-gonic/gin"

func main() {
	err := LoadArticles()
	if err != nil {
		panic(err)
	}

	g := gin.Default()
	r := NewRouter(g)
	r.Configure()

	r.Listen(3000)
}
