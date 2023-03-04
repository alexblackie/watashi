use askama::Template;
use actix_web::{web, http::header::ContentType, HttpResponse, Responder};
use crate::articles::{ArticleList, Articles, Article};

pub mod filters;

#[derive(Template)]
#[template(path = "home.html")]
struct IndexTemplate<'a> {
    nav: &'a str,
    articles: ArticleList,
}

pub async fn index(articles: web::Data<ArticleList>) -> impl Responder {
    let mut articles = articles.to_vec();
    articles.truncate(10);
    let tmpl = IndexTemplate {
        articles: articles.to_vec(),
        nav: "home",
    };

    HttpResponse::Ok()
        .insert_header(ContentType::html())
        .body(tmpl.render().unwrap())
}

#[derive(Template)]
#[template(path = "article_index.html")]
struct ArticleIndexTemplate<'a> {
    nav: &'a str,
    articles: ArticleList,
}

pub async fn article_index(articles: web::Data<ArticleList>) -> impl Responder {
    let tmpl = ArticleIndexTemplate {
        articles: articles.to_vec(),
        nav: "articles",
    };

    HttpResponse::Ok()
        .insert_header(ContentType::html())
        .body(tmpl.render().unwrap())
}

#[derive(Template)]
#[template(path = "feed.xml")]
struct ArticleFeedTemplate<'a> {
    articles: Vec<&'a crate::articles::Article>,
}

pub async fn article_feed(article_map: web::Data<Articles>) -> impl Responder {
    // manually sort the articles because we need the full content as well
    let mut articles: Vec<&crate::articles::Article> = article_map.values().collect();
    articles.sort_by(|a, b| b.meta.publish_date.cmp(&a.meta.publish_date));
    articles.truncate(10);

    let tmpl = ArticleFeedTemplate { articles };

    HttpResponse::Ok()
        .insert_header(ContentType::xml())
        .body(tmpl.render().unwrap())
}

#[derive(Template)]
#[template(path = "article_show.html", escape = "none")]
struct ArticleShowTemplate<'a> {
    nav: &'a str,
    article: &'a Article,
}

pub async fn article_show(
    path: web::Path<String>,
    articles: web::Data<Articles>,
) -> impl Responder {
    let slug = path.into_inner();
    let article = articles.get(slug.as_str());

    article.map_or_else(
        || HttpResponse::NotFound().body("Not found!"),
        |article| {
            let tmpl = ArticleShowTemplate {
                article,
                nav: "articles",
            };
            HttpResponse::Ok()
                .insert_header(ContentType::html())
                .body(tmpl.render().unwrap())
        },
    )
}

#[derive(Template)]
#[template(path = "setup.html")]
struct SetupTemplate<'a> {
    nav: &'a str,
}

pub async fn setup() -> impl Responder {
    let tmpl = SetupTemplate { nav: "setup" };
    HttpResponse::Ok()
        .insert_header(ContentType::html())
        .body(tmpl.render().unwrap())
}

#[derive(Template)]
#[template(path = "all_stars.html")]
struct AllStarsTemplate<'a> {
    nav: &'a str,
}

pub async fn all_stars() -> impl Responder {
    let tmpl = AllStarsTemplate { nav: "all-stars" };
    HttpResponse::Ok()
        .insert_header(ContentType::html())
        .body(tmpl.render().unwrap())
}
