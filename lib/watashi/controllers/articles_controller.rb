module Watashi
  module Controllers
    class ArticlesController < AbstractController

      def get
        slug = @captures[:slug]
        content_file = File.join(Watashi::BASE_DIR, "web", "articles", "#{slug}.html")
        meta_file = File.join(Watashi::BASE_DIR, "web", "articles", "#{slug}.yml")

        unless File.exist?(content_file) && File.exist?(meta_file)
          return respond_error(:not_found)
        end

        meta = YAML.load_file(meta_file)
        content = File.read(content_file)

        respond(template: "article_show", context: {
          body: content,
          page_title: meta["title"],
          date: meta["date"].strftime("%b %d, %Y"),
          stylesheets: meta["stylesheets"]
        })
      end

    end
  end
end
