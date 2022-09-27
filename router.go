package main

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

type Router struct {
	mux *gin.Engine
}

func NewRouter(g *gin.Engine) *Router {
	return &Router{mux: g}
}

func (r *Router) Configure() {
	r.mux.SetFuncMap(HelpersMap())
	r.mux.LoadHTMLGlob("templates/*")

	r.mux.Static("/_", "static/_")
	r.mux.Static("/images", "static/images")
	r.mux.StaticFile("/favicon.ico", "static/favicon.ico")

	r.mux.GET("/articles/:slug/", r.handleArticle())
	r.mux.GET("/articles/", r.handleArticleList())
	r.mux.GET("/setup/", r.handleSetup())
	r.mux.GET("/all-stars/", r.renderPage("all-stars.html"))
	r.mux.GET("/feed.xml", r.handleFeed())
	r.mux.GET("/", r.handleHome())
}

func (r *Router) Listen(port int) {
	r.mux.Run(fmt.Sprintf(":%d", port))
}

func (r *Router) renderPage(name string) gin.HandlerFunc {
	return func(c *gin.Context) {
		page, err := GetPage(name, Assigns{})
		if err != nil {
			fmt.Printf("Error while loading page! %v\n", err)
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Content": page,
			"Nav":     "none",
		})
	}
}

func (r *Router) handleHome() gin.HandlerFunc {
	return func(c *gin.Context) {
		content, err := GetPage("index.html", Assigns{"Articles": ListArticles(10)})
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Content": content,
			"Nav":     content.Meta.Nav,
		})
	}
}

func (r *Router) handleSetup() gin.HandlerFunc {
	return func(c *gin.Context) {
		page, err := GetPage("setup.html", Assigns{})
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Content": page,
			"Nav":     page.Meta.Nav,
		})
	}
}

func (r *Router) handleArticleList() gin.HandlerFunc {
	return func(c *gin.Context) {
		content, err := GetPage("articles.html", Assigns{"Articles": ListArticles(99999)})
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Content": content,
			"Nav":     content.Meta.Nav,
		})
	}
}

func (r *Router) handleArticle() gin.HandlerFunc {
	return func(c *gin.Context) {
		content, err := GetArticle(c.Param("slug"))
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.HTML(200, "article.html", gin.H{
			"Content": content,
			"Nav":     "articles",
			"IsOld":   IsArticleOld(content.Meta),
		})
	}
}

func (r *Router) handleFeed() gin.HandlerFunc {
	return func(c *gin.Context) {
		var articles []*Content
		for _, a := range ListArticles(10) {
			full, err := GetArticle(a.Slug[len("/articles/") : len(a.Slug)-1])
			if err != nil {
				panic(err)
			}
			articles = append(articles, full)
		}
		content, err := GetPage("feed.xml", Assigns{"Articles": articles})
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.Data(http.StatusOK, "application/rss+xml", []byte(*content.Parsed))
	}
}
