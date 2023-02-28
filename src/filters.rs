use std::{fmt::Display, fs::read_to_string};

use chrono::NaiveDate;

// askama filter that takes a NaiveDate and formats it as a human readable string
pub fn human_date(s: &NaiveDate) -> ::askama::Result<String> {
    let s = s.format("%d %B %Y").to_string();
    Ok(s)
}

// askama filter to parse a date with chrono and return an RFC 2822 formatted string
pub fn rfc_2822_date(s: &NaiveDate) -> ::askama::Result<String> {
    let s = s.format("%a, %d %b %Y 00:00:00 +0000").to_string();
    Ok(s)
}

pub fn permalink(s: &str) -> ::askama::Result<String> {
    let s = format!("https://www.alexblackie.com{}", s);
    Ok(s)
}

pub fn nav_class(want: &str, have: &str) -> ::askama::Result<String> {
    if want == have {
        return Ok("active".to_string());
    }
    Ok("".to_string())
}

pub fn icon<T: Display>(s: T) -> ::askama::Result<String> {
    let svg = read_to_string(format!("icons/{}.svg", s.to_string())).map_or_else(
        |_| "<svg><!-- Non existent icon! --></svg>".to_string(),
        |s| s,
    );
    Ok(svg)
}
