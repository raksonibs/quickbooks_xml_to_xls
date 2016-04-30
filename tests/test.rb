require "minitest/autorun"
require_relative '../index.rb'

describe QboXmlService do
  before do
    @service = QboXmlService.new
  end

  describe "when asked about fields" do
    it "must be empty" do
      @service.allQBFields.must_equal []
    end
  end

  describe "when asked about xml" do
    it "must be nil" do
      @service.xml.must_equal nil
    end
  end

  describe "when present xml" do
    it "must be formatted xml" do
      @service.preset_xml
      @service.xml.xpath('Report').children.count.must_equal 7
    end
  end
end