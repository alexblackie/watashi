require "spec_helper"

RSpec.describe Watashi::Services::DataBag do

  class TestModel
    PATH_KEY = "test_model".freeze

    attr_reader :id, :title

    def initialize(data)
      @id = data["id"]
      @title = data["title"]
    end
  end

  let(:service) do
    described_class.new(
      model: TestModel,
      base_dir: File.join(Watashi::BASE_DIR, "spec", "fixtures")
    )
  end

  describe ".all" do
    subject { service.all }

    it "returns a list of models" do
      expect(subject.map(&:class).uniq).to eq [TestModel]
    end
  end

  describe ".one" do
    context "with a valid ID" do
      subject { service.one("cd9669d1-7961-405f-94fb-0324a0e9b80e") }

      it "finds the record" do
        expect(subject.title).to eq "Example entry"
      end
    end

    context "with an invalid ID" do
      subject { service.one("you know, the one") }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end
  end

end
