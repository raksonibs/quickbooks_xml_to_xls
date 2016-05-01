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
      @service.preset_xml_to_string
      @service.xml.length.must_equal 4107
    end
  end

  describe "when present xml" do
    it "must be formatted xml" do
      @service.preset_xml_to_string
      formatted_xml = @service.string_xml_to_xml
      formatted_xml.xpath('Report').children.count.must_equal 7
    end
  end

  describe "when hash" do
    it "must be year to date" do
      @service.preset_xml_to_string
      @service.form_hash('')
      @service.allQBFields[0].keys[0].must_equal "Report"
      @service.allQBFields[0].keys[1].must_equal "term"
      @service.allQBFields[0]['term'].must_equal ""
      @service.allQBFields[0]['Report'].keys.must_equal ["Header", "Columns", "Rows"]      
    end
  end

  describe "output write when fields blank" do
    it "must be template" do
      @service.write_output_xml_file
      f = File.open('output.xml', 'r+')  
      f_string = f.read
      f_string.length.must_equal 1603
    end
  end

  describe "output write when hashed xml", focus: true do
    it "must be full file" do
      @service.preset_xml_to_string
      @service.form_hash('')
      @service.write_output_xml_file
      f = File.open('output.xml', 'r+')  
      f_string = f.read
      f_string.length.must_equal 5452      
    end
  end
end