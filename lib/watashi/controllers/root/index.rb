# frozen_string_literal: true

module Watashi
  module Controllers
    module Root
      class Index

        include Hanami::Action

        DEFAULT_PER_PAGE = 8

        def call(params)
          page = (params[:page] || 0).to_i
          service = Watashi::Services::DataBag.new(model: Watashi::Domain::Article)

          articles = service.all(
            sort: :date,
            per_page: DEFAULT_PER_PAGE,
            page: page
          )

          total_pages = service.total_pages(per_page: DEFAULT_PER_PAGE)

          ctx = {
            format: :html,
            articles: articles,
            current_page: page,
            total_pages: total_pages
          }

          self.body = ::Watashi::Views::Root::Index.render(ctx)
        end

      end
    end
  end
end
