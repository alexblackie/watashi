use actix_web::{
    dev::{Service as _, ServiceResponse},
    http::header::ContentType,
    middleware, web, App, HttpResponse, HttpServer, Responder,
};
use askama::Template;
use std::path::Path;

pub mod articles;
pub mod filters;

#[derive(Template)]
#[template(path = "home.html")]
struct IndexTemplate<'a> {
    nav: &'a str,
    articles: articles::ArticleList,
}

async fn index(articles: web::Data<articles::ArticleList>) -> impl Responder {
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
    articles: articles::ArticleList,
}

async fn article_index(articles: web::Data<articles::ArticleList>) -> impl Responder {
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
    articles: Vec<&'a articles::Article>,
}

async fn article_feed(article_map: web::Data<articles::Articles>) -> impl Responder {
    // manually sort the articles because we need the full content as well
    let mut articles: Vec<&articles::Article> = article_map.values().collect();
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
    article: &'a articles::Article,
}

async fn article_show(
    path: web::Path<String>,
    articles: web::Data<articles::Articles>,
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

async fn setup() -> impl Responder {
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

async fn all_stars() -> impl Responder {
    let tmpl = AllStarsTemplate { nav: "all-stars" };
    HttpResponse::Ok()
        .insert_header(ContentType::html())
        .body(tmpl.render().unwrap())
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        let articles = articles::discover(Path::new("./articles"));
        let mut sorted_articles: articles::ArticleList = articles.values().map(|a| a.meta.clone()).collect();
        sorted_articles.sort_by(|a, b| b.publish_date.cmp(&a.publish_date));

        App::new()
            .app_data(web::Data::new(articles))
            .app_data(web::Data::new(sorted_articles))

            // actix-web middleware that adds a trailing slash unless the path contains a dot, and
            // redirects to the new path.
            .wrap_fn(|req, srv| {
                let mut path = req.path().to_owned();
                if !path.ends_with('/') && !path.contains('.') {
                    path.push('/');
                    let res = HttpResponse::PermanentRedirect()
                        .insert_header((actix_web::http::header::LOCATION, path))
                        .finish();
                    let req = req.request().clone();
                    Box::pin(async { Ok(ServiceResponse::new(req, res)) })
                } else {
                    srv.call(req)
                }
            })
            .wrap(middleware::DefaultHeaders::new()
                  .add_content_type()
                  .add(("X-Content-Type-Options", "nosniff"))
                  .add(("X-XSS-Protection", "1; mode=block"))
                  .add(("Content-Security-Policy", "default-src 'self'; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline' https://plausible.io; connect-src https://plausible.io"))
                  .add(("Strict-Transport-Security", "max-age=7776000"))
                  .add(("X-Frame-Options", "DENY")))

            .service(actix_files::Files::new("/_", "./static/_"))
            .service(actix_files::Files::new("/images", "./static/images"))

            .route("/", web::get().to(index))
            .route("/setup/", web::get().to(setup))
            .route("/all-stars/", web::get().to(all_stars))
            .route("/feed.xml", web::get().to(article_feed))
            .route("/articles/", web::get().to(article_index))
            .route("/articles/{slug}/", web::get().to(article_show))
    })
    .bind(("0.0.0.0", 3000))?
    .run()
    .await
}
