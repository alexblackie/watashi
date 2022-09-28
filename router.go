package main

import (
	"fmt"
	"html/template"
	"net/http"

	"github.com/gin-gonic/gin"
)

type Router struct {
	mux         *gin.Engine
	PageRepo    IRepository
	ArticleRepo IRepository
}

func NewRouter(g *gin.Engine, articleRepo IRepository, pageRepo IRepository) *Router {
	return &Router{
		mux:         g,
		ArticleRepo: articleRepo,
		PageRepo:    pageRepo,
	}
}

func (r *Router) Configure() {
	r.mux.SetFuncMap(HelpersMap())
	r.mux.LoadHTMLGlob("templates/*")

	r.mux.Static("/_", "static/_")
	r.mux.Static("/images", "static/images")
	r.mux.StaticFile("/favicon.ico", "static/favicon.ico")

	r.mux.GET("/articles/:slug/", r.handleArticle())
	r.mux.GET("/articles/", r.handleArticleList())
	r.mux.GET("/setup/", r.renderPage("setup"))
	r.mux.GET("/all-stars/", r.renderPage("all-stars"))
	r.mux.GET("/feed.xml", r.handleFeed())
	r.mux.GET("/", r.handleHome())
}

func (r *Router) Listen(port int) {
	r.mux.Run(fmt.Sprintf(":%d", port))
}

func (r *Router) renderPage(name string) gin.HandlerFunc {
	return func(c *gin.Context) {
		page, err := r.PageRepo.Find(name)
		if err != nil {
			fmt.Printf("Error while loading page! %v\n", err)
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}
		rr, err := Render(page, Assigns{})
		if err != nil {
			fmt.Printf("Error while rendering page: %v\n", err)
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Page":    page,
			"Content": template.HTML(rr.Output),
			"Nav":     page.Meta.Nav,
		})
	}
}

func (r *Router) handleHome() gin.HandlerFunc {
	return func(c *gin.Context) {
		doc, err := r.PageRepo.Find("index")
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		rr, err := Render(doc, Assigns{"Articles": r.ArticleRepo.Latest(10)})
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Page":    doc,
			"Content": template.HTML(rr.Output),
			"Nav":     "",
		})
	}
}

func (r *Router) handleArticleList() gin.HandlerFunc {
	return func(c *gin.Context) {
		content, err := r.PageRepo.Find("articles")
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		rr, err := Render(content, Assigns{"Articles": r.ArticleRepo.Latest(99999)})
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Page":    content,
			"Content": template.HTML(rr.Output),
			"Nav":     "articles",
		})
	}
}

func (r *Router) handleArticle() gin.HandlerFunc {
	return func(c *gin.Context) {
		content, err := r.ArticleRepo.Find(c.Param("slug"))
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		rr, err := Render(content, Assigns{})
		c.HTML(200, "article.html", gin.H{
			"Page":    content,
			"Content": template.HTML(rr.Output),
			"Nav":     "articles",
		})
	}
}

func (r *Router) handleFeed() gin.HandlerFunc {
	return func(c *gin.Context) {
		var articles []*RenderResult
		for _, a := range r.ArticleRepo.Latest(10) {
			rr, err := Render(a, Assigns{})
			if err != nil {
				fmt.Printf("ERROR while rendering article: %v\n", err)
				c.AbortWithStatus(http.StatusInternalServerError)
				return
			}
			articles = append(articles, rr)
		}
		content, err := r.PageRepo.Find("feed")
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		rr, err := Render(content, Assigns{"Articles": articles})
		c.Data(http.StatusOK, "application/rss+xml", []byte(rr.Output))
	}
}
