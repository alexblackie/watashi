module.exports = {
  siteMetadata: {
    title: "Alex Blackie",
  },
  plugins: [
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