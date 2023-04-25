use actix_files::NamedFile;
use actix_web::{
    dev::{Service as _, ServiceResponse},
    middleware, web, App, HttpResponse, HttpServer,
};
use std::{env, path::Path};

pub mod articles;
pub mod templates;

#[derive(Clone)]
pub struct AppConfig {
    title: String,
    profile: String,
    port: u16,
    toolchain_version: &'static str,
    version: &'static str,
    head_commit: &'static str,
}

impl AppConfig {
    fn build() -> Self {
        AppConfig {
            title: env::var("APP_TITLE").unwrap_or_else(|_| "Alex Blackie".to_string()),
            profile: env::var("APP_PROFILE").unwrap_or_else(|_| "development".to_string()),
            port: env::var("PORT")
                .unwrap_or_else(|_| "3000".to_string())
                .parse()
                .unwrap(),
            toolchain_version: env!("TOOLCHAIN_VERSION"),
            version: env!("CARGO_PKG_VERSION"),
            head_commit: option_env!("HEAD_COMMIT").map_or("HEAD", |s| &s[0..9]),
        }
    }
}

async fn favicon() -> actix_web::Result<NamedFile> {
    Ok(NamedFile::open("./static/favicon.ico")?)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let app_config = AppConfig::build();
    let port = app_config.port;

    HttpServer::new(move || {
        let articles = articles::discover(Path::new("./articles"));
        let mut sorted_articles: articles::ArticleList = articles.values().map(|a| a.meta.clone()).collect();
        sorted_articles.sort_by(|a, b| b.publish_date.cmp(&a.publish_date));

        App::new()
            .app_data(web::Data::new(articles))
            .app_data(web::Data::new(sorted_articles))
            .app_data(web::Data::new(app_config.clone()))

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
                  .add(("Strict-Transport-Security", "max-age=7776000; preload"))
                  .add(("X-Frame-Options", "DENY"))
                  .add(("Referrer-Policy", "strict-origin-when-cross-origin"))
                  .add(("X-Permitted-Cross-Domain-Policies", "none"))
                  .add(("X-Download-Options", "noopen")))

            .service(actix_files::Files::new("/_", "./public/_"))
            .service(actix_files::Files::new("/images", "./public/images"))

            .route("/favicon.ico", web::get().to(favicon))
            .route("/", web::get().to(templates::index))
            .route("/setup/", web::get().to(templates::setup))
            .route("/all-stars/", web::get().to(templates::all_stars))
            .route("/feed.xml", web::get().to(templates::article_feed))
            .route("/articles/", web::get().to(templates::article_index))
            .route("/articles/{slug}/", web::get().to(templates::article_show))

            .default_service(web::route().to(templates::error_not_found))
    })
    .bind(("0.0.0.0", port))?
    .run()
    .await
}
