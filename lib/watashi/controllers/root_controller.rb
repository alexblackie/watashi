module Watashi
  module Controllers
    class RootController < AbstractController

      def get
        article_list = Dir
          .glob(File.join(Watashi::BASE_DIR, "web", "articles", "*.yml"))
          .delete_if{|d| d == "." || d == ".." }

        articles = article_list.map do |f|
          YAML.load_file(f).merge({"slug" => File.basename(f).gsub(/\.yml/, "")})
        end.sort{|a, b| b["date"] <=> a["date"]}

        respond(template: "index", context: {
          page_title: "The Internet Sensation&trade;",
          stylesheets: ["home"],
          articles: articles
        })
      end

    end
  end
end
