module.exports = {
  siteMetadata: {
    title: "Alex Blackie",
  },
  plugins: [
    "gatsby-plugin-react-helmet",
    {
      resolve: "gatsby-source-filesystem",
      options: {
        path: `${__dirname}/src/articles`,
        name: "markdown-pages",
      },
    },
    "gatsby-transformer-remark",
  ],
};