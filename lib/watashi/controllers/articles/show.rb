# frozen_string_literal: true

module Watashi
  module Controllers
    module Articles
      class Show

        include Hanami::Action
        include Watashi::Controllers::HandleErrors

        def call(params)
          article = Watashi::Services::DataBag
                    .new(model: Watashi::Domain::Article)
                    .one(params[:id])

          raise Watashi::Errors::RecordNotFound unless article

          self.body = Watashi::Views::Articles::Show.render(format: :html, article: article)
        end

      end
    end
  end
end
