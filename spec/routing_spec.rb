require "spec_helper"

RSpec.describe "Request Routing", type: :request do

  describe "GET /" do
    it "is successful" do
      get("/")
      expect(last_response.status).to eq(200)
    end

    it "calls the right controller" do
      expect_any_instance_of(Watashi::Controllers::RootController).to receive(:get).and_call_original
      get("/")
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

  describe "GET an asset" do
    before { get("/assets/css/site.css") }

    it "fetches the file" do
      # this is kind of a shitty thing but meh
      # just checks for common css-like characters
      expect(last_response.body).to match(%r/[{}:;]/)
    end

    it "detects the right mime type" do
      expect(last_response.headers["Content-Type"]).to eq "text/css"
    end
  end

end
