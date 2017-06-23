require "spec_helper"

RSpec.describe Watashi::Template do
  let(:fixture_views) { File.join(File.dirname(__FILE__), "..", "fixtures", "views") }

  subject(:service) { described_class.new(template_path: fixture_views) }

  describe "#render" do

    context "with a valid template" do
      it "renders the template" do
        expect(service.render("test_page")).to match(/<h1>rendered/)
      end

      it "renders the layout around the template" do
        expect(service.render("test_page")).to match(/doctype html/)
      end
    end

    context "with an invalid template" do
      it "returns nil" do
        expect(service.render("does_not_exist")).to be_nil
      end
    end

  end
end
