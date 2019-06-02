import React from "react";
import { Link, graphql } from "gatsby";
import Layout from "../components/layout";
import Container from "../components/container";
import Hero from "../components/hero";
import homeStyles from "../styles/home.module.css";

export default ({ data }) => (
  <Layout>
    <Hero lead="Salut! Je suis un développeur de logiciel à Montréal 🇨🇦" ctaLink="/projects" ctaText="Things I’ve Done">
      I work as a Software Developer (DevOps &amp; API) at <a href="https://getflow.com">Flow</a> and sometimes do things as <a href="https://github.com/blackieops">BlackieOps</a>. Over the years I have been fortunate to work on many challenging projects ranging from JS frontend apps, to high-performance backend APIs, to globally-redundant infrastructure.
    </Hero>

    <Container>
      <div className={ homeStyles.columns }>
        <div className={ homeStyles.articleColumn }>
          <header>
            <h2>Writing</h2>
          </header>

          <table className={ homeStyles.articleList }>
            <tbody>
              {data.allMarkdownRemark.edges.map(({ node }) => (
              <tr key="{node.id}">
                <td>{ node.frontmatter.date }</td>
                <td><Link to={`/articles${node.fields.slug}`}>{node.frontmatter.title}</Link></td>
              </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className={ homeStyles.contactColumn }>
          <h2>Where I am</h2>
          <dl>
            <dt>Github</dt>
            <dd><a href="https://github.com/alexblackie">@alexblackie</a></dd>

            <dt>Github</dt>
            <dd><a href="https://github.com/blackieops">@blackieops</a></dd>

            <dt>Email</dt>
            <dd><a href="mailto:alex@alexblackie.com">alex@alexblackie.com</a></dd>

            <dt>Keybase</dt>
            <dd><a href="https://keybase.io/alexblackie">@alexblackie</a></dd>
          </dl>
        </div>
      </div>
    </Container>
  </Layout>
);

export const pageQuery = graphql`
{
  allMarkdownRemark(sort: { fields: [frontmatter___date], order: DESC }) {
    edges {
      node {
        id
        fields {
          slug
        }
        frontmatter {
          date(formatString: "MMMM DD YYYY")
          title
          path
        }
      }
    }
  }
}
`;