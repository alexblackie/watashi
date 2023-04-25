use crate::articles::{Article, ArticleList, Articles};
use crate::AppConfig;
use actix_web::{http::header::ContentType, web, HttpResponse, Responder};
use askama::Template;

pub mod filters;

#[derive(Template)]
#[template(path = "home.html")]
struct IndexTemplate<'a> {
    config: &'a AppConfig,
    nav: &'a str,
    articles: ArticleList,
}

pub async fn index(
    config: web::Data<AppConfig>,
    articles: web::Data<ArticleList>,
) -> impl Responder {
    let mut articles = articles.to_vec();
    articles.truncate(10);
    let tmpl = IndexTemplate {
        config: &config,
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
    config: &'a AppConfig,
    nav: &'a str,
    articles: ArticleList,
}

pub async fn article_index(
    config: web::Data<AppConfig>,
    articles: web::Data<ArticleList>,
) -> impl Responder {
    let tmpl = ArticleIndexTemplate {
        config: &config,
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
    config: &'a AppConfig,
    nav: &'a str,
    article: &'a Article,
}

pub async fn article_show(
    config: web::Data<AppConfig>,
    path: web::Path<String>,
    articles: web::Data<Articles>,
) -> impl Responder {
    let slug = path.into_inner();
    let article = articles.get(slug.as_str());

    match article {
        Some(article) => {
            let tmpl = ArticleShowTemplate {
                config: &config,
                article,
                nav: "articles",
            };
            HttpResponse::Ok()
                .insert_header(ContentType::html())
                .body(tmpl.render().unwrap())
        }
        None => render_not_found(config),
    }
}

#[derive(Template)]
#[template(path = "setup.html")]
struct SetupTemplate<'a> {
    config: &'a AppConfig,
    nav: &'a str,
}

pub async fn setup(config: web::Data<AppConfig>) -> impl Responder {
    let tmpl = SetupTemplate {
        config: &config,
        nav: "setup",
    };
    HttpResponse::Ok()
        .insert_header(ContentType::html())
        .body(tmpl.render().unwrap())
}

#[derive(Template)]
#[template(path = "all_stars.html")]
struct AllStarsTemplate<'a> {
    config: &'a AppConfig,
    nav: &'a str,
}

pub async fn all_stars(config: web::Data<AppConfig>) -> impl Responder {
    let tmpl = AllStarsTemplate {
        config: &config,
        nav: "all-stars",
    };
    HttpResponse::Ok()
        .insert_header(ContentType::html())
        .body(tmpl.render().unwrap())
}

#[derive(Template)]
#[template(path = "error_not_found.html")]
struct ErrorNotFoundTemplate<'a> {
    config: &'a AppConfig,
    nav: &'a str,
}

pub async fn error_not_found(config: web::Data<AppConfig>) -> impl Responder {
    render_not_found(config)
}

fn render_not_found(config: web::Data<AppConfig>) -> HttpResponse {
    let tmpl = ErrorNotFoundTemplate {
        config: &config,
        nav: "",
    };
    HttpResponse::NotFound()
        .insert_header(ContentType::html())
        .body(tmpl.render().unwrap())
}
