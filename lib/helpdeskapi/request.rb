require 'rest-client'
require File.dirname(__FILE__) + '/authentication'

module HelpDeskAPI
  module Request
    @api = RestClient::Resource.new 'https://on.spiceworks.com/api/'

    # Contact API given endpoint and return JSON
    def self.request(method, endpoint, payload = nil, headers = {})
      headers = headers.merge({:cookies => HelpDeskAPI::Authentication.cookies})
      endpoint_response = nil
      case method
        when 'POST'
          @api[endpoint].post(payload, headers) do |response, request, result, &block|
            if responseError?(response)
              fail RequestError, "Error contacting #{response.request.url} with HTTP code: #{response.code}"
            end
            # Update cookies just incase
            HelpDeskAPI::Authentication.cookies = response.cookies
            endpoint_response = response
          end
        when 'GET'
          endpoint_response = @api[endpoint].get(headers)
          if responseError?(endpoint_response)
            fail RequestError, "Error contacting #{response.request.url} with HTTP code: #{response.code}"
          end
        when 'DELETE'
          endpoint_response = @api[endpoint].delete(headers)
          if responseError?(endpoint_response)
            fail RequestError, "Error contacting #{response.request.url} with HTTP code: #{response.code}"
          end
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
