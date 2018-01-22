module Watashi
  module Controllers
    class FeedController < Yokunai::AbstractController

      def get
        template_path = File.join(Yokunai::Config.base_dir, Yokunai::Config.get("template_dir"), "rss.xml.erb")
        service = Watashi::Services::DataBag.new(model: Watashi::Domain::Article)
        # only fetch "first page" (first 10)
        articles = service.all(
          sort: :date,
          per_page: 10,
          page: 0
        )
        context = { articles: articles }

        respond(
          body: ERB.new(File.read(template_path)).result(Yokunai::RenderContext.new(context).get_binding),
          headers: {"Content-Type" => "application/rss+xml"},
        )
      end

    end
  end
end
