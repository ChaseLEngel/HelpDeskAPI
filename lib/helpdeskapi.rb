require 'rest-client'
require 'nokogiri'
require 'json'

require File.dirname(__FILE__) + '/helpdeskapi/authentication'
require File.dirname(__FILE__) + '/helpdeskapi/ticket'
require File.dirname(__FILE__) + '/helpdeskapi/request'
require File.dirname(__FILE__) + '/helpdeskapi/tickets'
require File.dirname(__FILE__) + '/helpdeskapi/users'
require File.dirname(__FILE__) + '/helpdeskapi/organizations'
require File.dirname(__FILE__) + '/helpdeskapi/endpoints'
require File.dirname(__FILE__) + '/helpdeskapi/exceptions'

module HelpDeskAPI
  class Client

    def initialize(username, password)
      HelpDeskAPI::Authentication.username = username
      HelpDeskAPI::Authentication.password = password
      HelpDeskAPI::Authentication.authenticity_token = nil
      HelpDeskAPI::Authentication.cookies = nil
      sign_in
    end

    # Authenicate user and set cookies.
    # This will be called automatically on endpoint request.
    def sign_in
      # Contact sign in page to set cookies.
      begin
        sign_in_res = RestClient.get(Endpoints::SIGN_IN)
      rescue RestClient::ExceptionWithResponse => error
        fail HelpDeskAPI::Exceptions.SignInError, "Error contacting #{Endpoints::SIGN_IN}: #{error}"
      end

      # Parse authenticity_token from sign in form.
      page = Nokogiri::HTML(sign_in_res)
      HelpDeskAPI::Authentication.authenticity_token = page.css('form').css('input')[1]['value']
      unless HelpDeskAPI::Authentication.authenticity_token
        fail HelpDeskAPI::Exceptions.AuthenticityTokenError, 'Error parsing authenticity_token: Token not found.'
      end
      # Parse sign_in HTML for csrf-token
      page.css('meta').each do |tag|
        HelpDeskAPI::Authentication.csrf_token = tag['content'] if tag['name'] == 'csrf-token'
      end
      unless HelpDeskAPI::Authentication.csrf_token
        fail HelpDeskAPI::Exceptions.CsrfTokenError, 'No csrf-token found'
      end

      # Set cookies for later requests
      HelpDeskAPI::Authentication.cookies = sign_in_res.cookies

      # Simulate sign in form submit button.
      body = {
        'authenticity_token': HelpDeskAPI::Authentication.authenticity_token,
        'user[email_address]': HelpDeskAPI::Authentication.username,
        'user[password]': HelpDeskAPI::Authentication.password
      }
      RestClient.post(Endpoints::SESSIONS, body, {:cookies => HelpDeskAPI::Authentication.cookies}) do |response, request, result, &block|
        # Response should be a 302 redirect from /sessions
        if Request::responseError?(response)
          fail HelpDeskAPI::Exceptions.SessionsError, "Error contacting #{Endpoints::SESSIONS}: #{error}"
        end
        # Update cookies just incase
        HelpDeskAPI::Authentication.cookies = response.cookies
      end
    end
  end
end
