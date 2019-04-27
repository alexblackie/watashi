# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Request Routing", type: :request do
  describe "GET /about" do
    it "is successful" do
      get("/about")
      expect(last_response.status).to eq(200)
    end

    it "calls the right controller" do
      expect_any_instance_of(Watashi::Controllers::PagesController).to receive(:get).and_call_original
      get("/about")
    end
  end

  describe "GET a non-existent route" do
    it "is a 404" do
      get("/thisisnotaroutethatexists")
      expect(last_response.status).to eq(404)
    end
  end

  describe "GET a legacy path" do
    it "redirects to the new one" do
      get("/about.shtml")
      expect(last_response.headers["Location"]).to eq("/about")
    end
  end
end
