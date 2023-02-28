use glob::glob;
use serde::Deserialize;
use std::{collections::HashMap, fs, path::Path};

pub type Articles = HashMap<String, Article>;
pub type ArticleList = Vec<ArticleMeta>;

#[derive(Debug, Deserialize, Clone)]
pub struct ArticleMeta {
    pub title: String,
    pub slug: String,
    pub publish_date: chrono::NaiveDate,
    pub updated_date: Option<chrono::NaiveDate>,
    pub cover: Option<ArticleCover>,
}

#[derive(Debug, Deserialize, Clone)]
pub struct ArticleCover {
    pub url: String,
    pub alt: String,
    pub width: u32,
    pub height: u32,
}

#[derive(Debug, Deserialize, Clone)]
pub struct Article {
    pub meta: ArticleMeta,
    pub content: String,
}

pub fn parse_article(raw: String) -> Result<Article, String> {
    let parts: Vec<&str> = raw.split_terminator("---").collect();
    match serde_yaml::from_str::<ArticleMeta>(parts.first().unwrap()) {
        Ok(meta) => Ok(Article {
            meta,
            content: parts.last().unwrap().to_string(),
        }),
        Err(e) => Err(format!("Failed to parse article frontmatter: {}", e)),
    }
}

pub fn discover(base_dir: &Path) -> Articles {
    let mut articles: Articles = Articles::new();
    glob(base_dir.join("**").join("*").to_str().unwrap())
        .expect("Failed to find articles.")
        .into_iter()
        .map(|p| p.unwrap().as_path().to_owned())
        .for_each(|file_path| match fs::read_to_string(file_path) {
            Ok(raw) => {
                let article = parse_article(raw).unwrap();
                articles.insert(article.meta.slug.clone(), article);
            }
            Err(_) => {}
        });
    articles
}
