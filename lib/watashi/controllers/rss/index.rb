# frozen_string_literal: true

module Watashi
  module Controllers
    module Rss
      class Index

        include Hanami::Action

        def call(_params)
          service = Watashi::Services::DataBag.new(model: Watashi::Domain::Article)
          # only fetch "first page" (first 10)
          articles = service.all(
            sort: :date,
            per_page: 10,
            page: 0
          )

          self.body = ::Watashi::Views::Rss::Index.render(format: :xml, articles: articles)
          self.headers["Content-Type"] = "application/rss+xml"
        end

      end
    end
  end
end
