require 'rest-client'

require File.dirname(__FILE__) + '/authentication'
require File.dirname(__FILE__) + '/endpoints'

module HelpDeskAPI
  module Request
    @api = RestClient::Resource.new Endpoints::API_URL

    # Contact API given endpoint and return JSON
    def self.request(method, endpoint, payload = nil, headers = {})
      headers = headers.merge({:cookies => HelpDeskAPI::Authentication.cookies})
      endpoint_response = nil

      case method
        when 'POST'
          @api[endpoint].post(payload, headers) { |response, _, _, _| endpoint_response = response }
        when 'GET'
          endpoint_response = @api[endpoint].get(headers)
        when 'DELETE'
          endpoint_response = @api[endpoint].delete(headers)
        when 'PUT'
          endpoint_response = @api[endpoint].put(payload, headers)
      end

      if responseError?(endpoint_response)
        fail RequestError, "Error contacting #{endpoint_response.request.url} with HTTP code: #{endpoint_response.code}"
      end

      return endpoint_response
    end

    # Returns true if response contains HTTP error code.
    def self.responseError?(response)
      error_codes = [400, 401, 402, 403, 404, 500, 501, 502, 503]
      error_codes.include? response.code
    end
  end
end
