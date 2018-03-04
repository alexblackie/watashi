require "spec_helper"

RSpec.describe Watashi::Services::DataBag do

  class TestModel
    PATH_KEY = "test_model".freeze

    attr_reader :id, :title

    def initialize(data)
      @id = data["id"]
      @title = data["title"]
      @data = data
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

    context "when a model supports holding" do
      before do
        TestModel.class_eval do
          def held?
            @data["hold"]
          end
        end
      end

      it "doesn't return held models" do
        expect(subject.map(&:title)).to_not include("A third example")
      end

      it "still finds the unheld models" do
        expect(subject.map(&:title)).to include("Example entry")
      end
    end

    describe "pagination" do
      describe "page" do
        subject { service.all(per_page: 2, page: page) }

        context "with a normal page" do
          let(:page) { 1 }
          it "offsets" do
            expect(subject.size).to eq 1
          end
        end

        context "when the page is out-of-bounds" do
          let(:page) { 100 }
          it { is_expected.to be_empty }
        end
      end

      describe "per_page" do
        subject { service.all(per_page: per_page) }

        context "with a normal per_page" do
          let(:per_page) { 1 }
          it "limits results" do
            expect(subject.size).to eq 1
          end
        end

        context "with a too-large per_page" do
          let(:per_page) { 1000 }
          it "still returns everything" do
            expect(subject.size).to eq 3
          end
        end

        context "with a negative per_page" do
          let(:per_page) { -69 }
          it "doesn't go below one" do
            expect(subject.size).to eq 1
          end
        end
      end
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
