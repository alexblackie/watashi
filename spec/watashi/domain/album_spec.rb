# frozen_string_literal: true

require "spec_helper"

RSpec.describe Watashi::Domain::Album do
  let!(:album) { described_class.new(data) }
  let(:data) do
    {
      "title" => "An example album",
      "id" => "92345cfc-0be7-41d0-8fd5-4d55488a0b6b",
      "publish_date" => "2017-02-30",
      "photo_sets" => [
        "c3e6d391-7a4a-4376-8433-d4bab75722a4",
        "20b1da96-9f76-44b6-bb6d-72f356d0a1a4",
        "c02924ce-2f6a-48ab-9337-5d4893dbd9f1"
      ]
    }
  end

  describe "#cover_photo_url" do
    subject { album.cover_photo_url }

    it "contains the id" do
      expect(subject).to include "92345cfc-0be7-41d0-8fd5-4d55488a0b6b"
    end

    it "contains the cdn url" do
      expect(subject).to include "cdn.blackieops.com"
    end
  end

  describe "readers" do
    it "exposes the data" do
      expect(album.id).to eq "92345cfc-0be7-41d0-8fd5-4d55488a0b6b"
      expect(album.title).to eq "An example album"
      expect(album.publish_date).to eq "2017-02-30"
    end
  end
end
