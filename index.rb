require_relative 'secrets.rb'
require 'pry'
require 'oauth'
require 'quickbooks-ruby'

m = HashThing.new()
qb_oauth_consumer = OAuth::Consumer.new(m.qb_key, m.qb_secret, {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "/oauth/v1/get_request_token",
    :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
    :access_token_path    => "/oauth/v1/get_access_token"
})

def get_hash(qb_oauth_consumer, m)
  qb_client = OAuth::AccessToken.new(qb_oauth_consumer, m.access_token, m.qb_secret)
  
  qb_fields_hash = get_qb_fields(qb_client, m)
  binding.pry
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
      hash = Hash.from_xml(report_service.last_response_xml.to_s)
      hash['term'] = term
      allQBFields << hash
    end
  end

  allQBFields

end

get_hash(qb_oauth_consumer, m)