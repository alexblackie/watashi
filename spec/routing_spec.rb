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

end
