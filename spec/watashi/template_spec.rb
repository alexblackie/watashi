require "spec_helper"

RSpec.describe Watashi::Template do
  let(:fixture_views) { File.join(File.dirname(__FILE__), "..", "fixtures", "views") }

  subject(:service) { described_class.new(template_path: fixture_views) }

  describe "#render" do

    context "with a valid template" do
      it "renders the template" do
        expect(service.render("test_page")).to match /<h1>rendered/
      end

      it "only renders it once" do
        expect(File).to receive(:read).exactly(1).times.and_call_original
        service.render("test_page")
        service.render("test_page")
      end
    end

    context "with an invalid template" do
      it "returns nil" do
        expect(service.render("does_not_exist")).to be_nil
      end
    end

  end
end
