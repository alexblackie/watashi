require "spec_helper"

RSpec.describe Watashi::Config do

  before do
    Watashi::Config.populate
  end

  describe ".get" do
    it "fetches from the YAML config" do
      expect(Watashi::Config.get("some_key")).to eq "get me"
    end

    it "returns nil for unknown keys" do
      expect(Watashi::Config.get("this_is_not_a_key")).to be_nil
    end
  end

end
