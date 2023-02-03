package main

import (
	"embed"
	"fmt"
	"html/template"
	"io/fs"
	"net/http"

	"github.com/gin-gonic/gin"
)

//go:embed static/_ static/favicon.ico
var staticEmbedded embed.FS

func httpSubFS(sysfs fs.FS, prefix string) http.FileSystem {
	newFS, err := fs.Sub(sysfs, prefix)
	if err != nil {
		panic(err)
	}
	return http.FS(newFS)
}

var underscoreFS = httpSubFS(staticEmbedded, "static/_")
var staticFS = httpSubFS(staticEmbedded, "static")

//go:embed templates/*
var templateFS embed.FS

type Router struct {
	mux         *gin.Engine
	Config      *Config
	PageRepo    IRepository
	ArticleRepo IRepository
}

func NewRouter(g *gin.Engine, config *Config, articleRepo IRepository, pageRepo IRepository) *Router {
	return &Router{
		mux:         g,
		Config:      config,
		ArticleRepo: articleRepo,
		PageRepo:    pageRepo,
	}
}

func (r *Router) Configure() {
	if r.Config.IsProduction() {
		tmpls := template.Must(template.New("").Funcs(HelpersMap(r.Config)).ParseFS(templateFS, "templates/*"))
		r.mux.SetHTMLTemplate(tmpls)
		r.mux.StaticFS("/_", underscoreFS)
	} else {
		r.mux.SetFuncMap(HelpersMap(r.Config))
		r.mux.LoadHTMLGlob("templates/*")
		r.mux.Static("/_", "static/_")
	}


	r.mux.NoRoute(r.renderNotFound)

	r.mux.StaticFileFS("/favicon.ico", "favicon.ico", staticFS)
	r.mux.Static("/images", r.Config.ImagesPath)

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
		rr, err := Render(page, Assigns{}, r.Config)
		if err != nil {
			fmt.Printf("Error while rendering page: %v\n", err)
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}
		c.HTML(http.StatusOK, "page.html", gin.H{
			"Config":  r.Config,
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
		rr, err := Render(doc, Assigns{"Articles": r.ArticleRepo.Latest(10)}, r.Config)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Config":  r.Config,
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
			r.renderNotFound(c)
			return
		}
		rr, err := Render(content, Assigns{"Articles": r.ArticleRepo.Latest(99999)}, r.Config)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.HTML(200, "page.html", gin.H{
			"Config":  r.Config,
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
			r.renderNotFound(c)
			return
		}
		rr, err := Render(content, Assigns{}, r.Config)
		c.HTML(200, "article.html", gin.H{
			"Config":  r.Config,
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
			rr, err := Render(a, Assigns{}, r.Config)
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
		rr, err := Render(content, Assigns{"Articles": articles}, r.Config)
		c.Data(http.StatusOK, "application/rss+xml", []byte(rr.Output))
	}
}

func (r *Router) renderNotFound(c *gin.Context) {
	page := &Document{
		Meta: &DocumentMeta{
			Title: "Not Found!",
		},
	}
	c.HTML(http.StatusNotFound, "error_not_found.html", gin.H{
		"Config": r.Config,
		"Page": page,
		"Nav": "none",
	})
}
