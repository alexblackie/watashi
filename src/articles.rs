use glob::glob;
use serde::Deserialize;
use std::{collections::HashMap, fs, path::Path};

pub type Articles = HashMap<String, Article>;
pub type ArticleList = Vec<ArticleMeta>;

#[derive(Debug, Deserialize, Clone)]
pub struct ArticleMeta {
    pub title: String,
    pub slug: String,
    pub evergreen: Option<bool>,
    pub publish_date: chrono::NaiveDate,
    pub updated_date: Option<chrono::NaiveDate>,
    pub cover: Option<ArticleCover>,
    pub open_graph_meta: Option<ArticleOpenGraphMeta>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct ArticleCover {
    pub url: String,
    pub alt: String,
    pub width: u32,
    pub height: u32,
}

#[derive(Debug, Deserialize, Clone)]
pub struct ArticleOpenGraphMeta {
    pub title: String,
    pub description: String,
    pub image_url: Option<String>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct Article {
    pub meta: ArticleMeta,
    pub content: String,
}

pub fn parse_article(raw: String, ext: &str) -> Result<Article, String> {
    let mut parts = raw.splitn(2, "---");
    let meta = parts.next().unwrap();
    let content = parts.next().unwrap();
    match serde_yaml::from_str::<ArticleMeta>(meta) {
        Ok(meta) => Ok(Article {
            meta,
            content: if ext == "md" {
                parse_content(content.to_string())
            } else {
                content.to_string()
            },
        }),
        Err(e) => Err(format!("Failed to parse article frontmatter: {}", e)),
    }
}

fn parse_content(raw: String) -> String {
    let mut parser = pulldown_cmark::Parser::new(&raw);
    let mut html_output = String::new();
    pulldown_cmark::html::push_html(&mut html_output, &mut parser);
    html_output
}

pub fn discover(base_dir: &Path) -> Articles {
    let mut articles: Articles = Articles::new();
    glob(base_dir.join("**").join("*").to_str().unwrap())
        .expect("Failed to find articles.")
        .into_iter()
        .map(|p| p.unwrap().as_path().to_owned())
        .for_each(|file_path| match fs::read_to_string(&file_path) {
            Ok(raw) => {
                let article =
                    parse_article(raw, file_path.extension().unwrap().to_str().unwrap()).unwrap();
                articles.insert(article.meta.slug.clone(), article);
            }
            Err(_) => {}
        });
    articles
}
