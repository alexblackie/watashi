require "spec_helper"

RSpec.describe Watashi::Domain::PhotoSet do

  before do
    Yokunai::Config.populate("fixture")
  end

  let(:entity) { described_class.new(data) }
  let(:data) {{
    "title" => "Mein Fotos",
    "description" => "<p>This is an photos.</p>",
    "album_id" => "794780fb-5f7f-4521-a353-b8d64d6718f8",
    "photos" => [
      "6fd2b956-098b-4c97-a635-3fe2e87bc51a",
      "eb809700-8fc3-44d5-803d-5faf470728a7",
      "8a6cd1e8-f8ae-438b-91e4-6a96a1ec6dbf",
      "bc9c47d9-ef75-42e5-a75a-24d1c008c80f",
      "ac1b5fc8-986c-40e1-915a-524f3c31acda"
    ]
  }}

  describe "#photo_urls" do
    subject { entity.photo_urls }

    it "contains the CDN URL" do
      expect(subject.sample).to include "cdn.example.com"
    end

    it "contains the photo id" do
      expect(subject.first).to include "6fd2b956-098b-4c97-a635-3fe2e87bc51a.jpg"
    end
  end

end
