require "spec_helper"

RSpec.describe Watashi::Domain::Article do
  subject(:article) { described_class.new(data) }

  let(:data) {{
    "id" => "test-article",
    "title" => "Me Post",
    "date" => Date.parse("2063-04-05"),
    "filename" => File.join(File.dirname(__FILE__), "..", "..", "fixtures", "articles", "test-article.yml")
  }}

  describe "#published_on" do
    subject { article.published_on }

    it "formats the date for humans" do
      # double-space after month because strftime I guess
      expect(subject).to eq "April  5, 2063"
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
