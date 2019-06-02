import React from "react";
import { graphql } from "gatsby";
import Layout from "./layout";
import Container from "./container";

import articleStyles from "../styles/article.module.css";

const ArticleCover = ({ imageUrl, caption, width, height }) => (
  <div className={ articleStyles.cover }>
    <img src={ imageUrl } alt={ caption } width={ width } height={ height } />
  </div>
);

export default function Template({ data }) {
  const { markdownRemark } = data;
  const { frontmatter, html } = markdownRemark;
  return (
    <Layout>
      <Container>
        <article>
          <header className={ articleStyles.header }>
            <h1>{frontmatter.title}</h1>
            <div className={ articleStyles.meta }>
              Published {frontmatter.date} by Alex Blackie.
            </div>
          </header>

          {frontmatter.cover ?
            <ArticleCover imageUrl={frontmatter.cover.url}
                          caption={frontmatter.cover.caption}
                          width={frontmatter.cover.width}
                          height={frontmatter.cover.height} /> : null}

          <div
            className={ articleStyles.content }
            dangerouslySetInnerHTML={{ __html: html }}
          />
        </article>
      </Container>
    </Layout>
  );
};

export const pageQuery = graphql`
  query($path: String!) {
    markdownRemark(frontmatter: { path: { eq: $path } }) {
      html
      frontmatter {
        date(formatString: "MMMM DD YYYY")
        path
        title
        cover {
          url
          caption
          width
          height
        }
      }
    }
  }
`;