require "spec_helper"

RSpec.describe Watashi::RenderContext do

  describe "#set" do
    it "provides the variable on the binding" do
      service = described_class.new({some_test: "it works"})
      expect(eval("some_test", service.get_binding)).to eq "it works"
    end
  end

  describe "#method_missing" do
    it "returns a nice message for unset variables" do
      service = described_class.new
      expect(eval("not_a_thing", service.get_binding)).to match(/No such context key/)
    end
  end

end
