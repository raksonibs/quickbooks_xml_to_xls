# example response:
# ------ QUICKBOOKS-RUBY REQUEST ------
# METHOD = get
# RESOURCE = https://sandbox-quickbooks.api.intuit.com/v3/company/123145759723942/reports/CashFlow?date_macro=This+Fiscal+Year-to-date
# REQUEST BODY:
# {}
# REQUEST HEADERS = {"Content-Type"=>"application/xml", "Accept"=>"application/xml", "Accept-Encoding"=>"gzip, deflate"}
# ------ QUICKBOOKS-RUBY RESPONSE ------
# RESPONSE CODE = 200
# RESPONSE BODY:

require_relative 'secrets.rb'
require 'pry'
require 'oauth'
require 'quickbooks-ruby'
require 'nokogiri'

class QboXmlService
  attr_accessor :xml, :allQBFields, :qb_oauth_consumer, :request_token, :m

  def initialize(xml = nil)
    @xml = xml
    @allQBFields = []
    # secret container for now
    @m = HashThing.new()
    @qb_oauth_consumer = OAuth::Consumer.new(m.qb_key, m.qb_secret, {
        :site                 => "https://oauth.intuit.com",
        :request_token_path   => "/oauth/v1/get_request_token",
        :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
        :access_token_path    => "/oauth/v1/get_access_token"
    })
    @request_token = @qb_oauth_consumer.get_request_token
    @row_data = []
  end

  def get_hash(qb_oauth_consumer, m)
    qb_client = OAuth::AccessToken.new(@qb_oauth_consumer, @m.access_token, @m.qb_secret)

    qb_fields_hash = get_qb_fields(qb_client, @m)
  end

  def assumed_hash
    hash = @m.hash
    file_name = "qbo_data.xls"
    
    File.open("../output.xml") do
      |f| f.write("write your stuff here") 
    end
    # send_data(stream, :type=>"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :filename => file_name)
  end

  def write_output_xml_file
    output = File.open("./views/blank_template.xml.erb", "r+")
    file_string = output.read
    split_document = file_string.split("<cut>")
    innerText = create_inner_xml
    output.close
    File.open('output.xml', "w+") {|f| f.write(split_document[0] + innerText + split_document[1])}
  end

  def create_inner_xml
    unless @allQBFields.blank?
      stringOutput = ""
      @allQBFields.each do |report|
        # headers first
        innerReport = report['Report']
        headers = innerReport['Header']
        headers.each do |header_key, header_value|
          stringOutput << "<Row>"
          stringOutput << "<Cell><Data ss:Type='String'>#{header_key}</Data></Cell>"
          stringOutput << "<Cell><Data ss:Type='String'>#{header_value}</Data></Cell>"
          stringOutput << "</Row>"
        end
        
        stringOutput << "<Row></Row>" 

        # column names next
        columns = innerReport['Columns']["Column"]
        stringOutput << "<Row>"
        columns.each do |column|
          stringOutput << "<Cell><Data ss:Type='String'>#{column['ColTitle']}</Data></Cell>"          
        end
        stringOutput << "</Row>"
        
        stringOutput << "<Row></Row>" 

        #now rows
        rows = parse_rows(innerReport["Rows"]["Row"])
        @row_data.flatten!
        binding.pry
        stringOutput << "<Row></Row>"       
      end
      stringOutput
    else
      ""
    end
  end

  def parse_rows(rows)
    header = []
    rowsParsed = []
    summary = []
    if rows.class.to_s == "Hash" && rows.keys.include?("ColData")
      return rows["ColData"]
    elsif rows.class.to_s == "Hash" && rows.keys.include?("Header")
        header = rows['Header']["ColData"]
        summary = rows['Summary']["ColData"]
        rowsParsed = parse_rows(rows["Rows"]["Row"])
        @row_data << header
        @row_data << rowsParsed
        @row_data << summary
    else
      rows.each do |internalRow|
        begin
        if internalRow.keys.include?("Header")
          header = internalRow['Header']["ColData"]
          summary = internalRow['Summary']["ColData"]
          rowsParsed = parse_rows(internalRow["Rows"]["Row"])
        else        
          if internalRow.keys.include?("ColData")
            return internalRow["ColData"]
          elsif internalRow.keys.include?("Summary")
            return internalRow["Summary"]["ColData"]
          else
            return internalRow["Rows"]["Row"]
          end
        end  
        @row_data << header
        @row_data << rowsParsed
        @row_data << summary
        rescue
          binding.pry
        end
      end
    end
  
  end

  def get_qb_fields(qb_client, m)  
    report_service = Quickbooks::Service::Reports.new({access_token: qb_client, company_id: m.uid})  
    allQBFields = []
    terms = ['', 'This Month', 'Last Month', 'This Fiscal Quarter', 'Last Fiscal Quarter']
    fields = [{"BalanceSheet" => terms}, {"CashFlow" => terms}, {"ProfitAndLoss" => terms}, {'GeneralLedger' => terms}]

    fields.each do |queries|
      queryString = queries.keys[0]
      queryTerms = queries.values[0]
      queryTerms.each do |term|
        if term != ""        
          report_service.query(queryString, term)
        else
          begin
            report_service.query(queryString)
          rescue
          end
        end
        @xml = report_service.last_response.to_s
        form_hash(term)
      end
    end

    allQBFields
  end

  def form_hash(term)
    unless @xml.nil?
      hash = Hash.from_xml(@xml)
      hash['term'] = term
      @allQBFields << hash
      @allQBFields
    end
  end

  def preset_xml_to_string
    doc = File.open("./views/shortened_cashflow.xml") { |f| Nokogiri::XML(f) }
    doc.remove_namespaces!
    @xml = doc.to_s
  end

  def string_xml_to_xml
    Nokogiri::XML(@xml)
  end

end

