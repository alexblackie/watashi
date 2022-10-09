package main

import (
	"flag"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

var (
	port        = flag.Int("port", 3000, "Set the web server listening port.")
	imagesPath  = flag.String("images", "./static/images", "Path to where images are stored.")
	articlePath = flag.String("articles", "./articles", "Path to the directory containing the article documents.")
	pagePath    = flag.String("pages", "./pages", "Path to the directory containing the page documents.")
)

func main() {
	flag.Parse()

	logger, err := zap.NewProduction()
	if err != nil {
		panic(err)
	}

	articleRepo := NewMemoryRepository(*articlePath, "/articles")
	if err := articleRepo.Preload(); err != nil {
		panic(err)
	}

	pageRepo := NewMemoryRepository(*pagePath, "/")
	if err := pageRepo.Preload(); err != nil {
		panic(err)
	}

	g := gin.New()
	g.Use(gin.Recovery(), requestLogger(logger))
	r := NewRouter(g, *imagesPath, articleRepo, pageRepo)
	r.Configure()

	r.Listen(*port)
}

func requestLogger(logger *zap.Logger) gin.HandlerFunc {
	return func(c *gin.Context) {
		requestStart := time.Now()
		c.Next()

		logger.Info("Request Processed",
			zap.String("method", c.Request.Method),
			zap.Int("status_code", c.Writer.Status()),
			zap.String("path", c.Request.URL.Path),
			zap.Duration("latency", time.Since(requestStart)),
		)
	}
}
