require "spec_helper"

RSpec.describe Watashi::Mime do

  describe ".detect_from_path" do
    subject { described_class.detect_from_path(path, "application/octet-stream") }

    context "with a known type" do
      let(:path) { "images/butt.jpeg" }

      it "returns the right mime type" do
        expect(subject).to eq "image/jpeg"
      end
    end

    context "with an unknown type" do
      let(:path) { "uploads/file.butt" }

      it "returns the fallback" do
        expect(subject).to eq "application/octet-stream"
      end
    end

  end

end
