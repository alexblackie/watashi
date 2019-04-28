# frozen_string_literal: true

module Watashi
  module Controllers
    module Pages
      class Show

        include Hanami::Action
        include Watashi::Controllers::HandleErrors

        def call(params)
          slug = params[:id]
          meta = Watashi::Services::DataBag.new(model: Watashi::Domain::Page).one(slug)

          raise Watashi::Errors::RecordNotFound if meta.nil?

          ctx = {
            format: :html,
            page_meta: meta,
            slug: slug
          }

          self.body = Watashi::Views::Pages::Show.render(ctx)
        end

      end
    end
  end
end
