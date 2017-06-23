require "spec_helper"

RSpec.describe Watashi::Domain::Article do
  let(:base_path) { File.join(File.dirname(__FILE__), "..", "..", "fixtures", "articles") }
  let(:file) { File.join(base_path, "test-article.yml") }

  subject(:article) { described_class.new(file) }

  describe ".catalogue" do
    subject { described_class.catalogue(base_path) }

    it { is_expected.to be_an Array }

    it "consists of Articles" do
      expect(subject.first).to be_a Watashi::Domain::Article
    end
  end

  describe ".find" do
    subject { described_class.find(slug, base_path) }

    context "with an existing slug" do
      let(:slug) { "test-article" }

      it "finds the right article" do
        expect(subject.title).to eq "Some Test Article"
      end
    end

    context "with a non-existent slug" do
      let(:slug) { "i-just-made-this-up" }

      it { is_expected.to be_nil }
    end
  end

  describe "#published_on" do
    subject { article.published_on }

    it "formats the date for humans" do
      expect(subject).to eq "December 21, 1995"
    end
  end

  describe "#slug" do
    subject { article.slug }

    it "strips the extension" do
      expect(subject).to eq "test-article"
    end
  end

  describe "#content" do
    subject { article.content }

    it "lazily loads" do
      expect(File).to receive(:read).exactly(1).times
      subject
    end

    it "returns the content from the file" do
      expect(subject).to match(/is an article/)
    end
  end

end
