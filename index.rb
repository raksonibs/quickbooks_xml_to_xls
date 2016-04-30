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
    # access_token = request_token.get_access_token(:oauth_verifier => m.oauth_verifier)
    # m.request_token = request_token
  end
  




  def get_hash(qb_oauth_consumer, m)
    qb_client = OAuth::AccessToken.new(@qb_oauth_consumer, @m.access_token, @m.qb_secret)

    qb_fields_hash = get_qb_fields(qb_client, @m)
  end

  def assumed_hash
    hash = @m.hash
    file_name = "qbo_data.xls"
    stream = File.open("./views/qbo.xml.erb")
    send_data(stream, :type=>"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :filename => file_name)
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
    hash = Hash.from_xml(@xml)
    hash['term'] = term
    @allQBFields << hash
    @allQBFields
  end

  def preset_xml
    stream = File.open("./views/cashflow.xml")
    @xml = steam.to_s
  end

end

