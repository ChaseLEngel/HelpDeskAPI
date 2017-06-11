require 'rest-client'
require 'nokogiri'
require 'json'

require File.dirname(__FILE__) + '/helpdeskapi/authentication'
require File.dirname(__FILE__) + '/helpdeskapi/ticket'
require File.dirname(__FILE__) + '/helpdeskapi/request'
require File.dirname(__FILE__) + '/helpdeskapi/tickets'

module HelpDeskAPI
  class Client
    SignInError  = Class.new(StandardError)
    AuthenticityTokenError = Class.new(StandardError)
    CsrfTokenError = Class.new(StandardError)
    SessionsError = Class.new(StandardError)
    NoCreatorIdError = Class.new(StandardError)
    RequestError = Class.new(StandardError)
    OrganizationIdError = Class.new(StandardError)

    URL = 'https://on.spiceworks.com/'
    API_URL = URL + 'api/'

    def initialize(username, password)
      @api = RestClient::Resource.new(API_URL)
      @creator_id = nil
      Authentication.username = username
      Authentication.password = password
      Authentication.authenticity_token = nil
      Authentication.cookies = nil
      sign_in
    end

    # Authenicate user and set cookies.
    # This will be called automatically on endpoint request.
    def sign_in
      # Contact sign in page to set cookies.
      begin
        sign_in_res = RestClient.get(URL + 'sign_in')
      rescue RestClient::ExceptionWithResponse => error
        fail SignInError, "Error contacting #{URL + 'sign_in'}: #{error}"
      end

      # Parse authenticity_token from sign in form.
      page = Nokogiri::HTML(sign_in_res)
      Authentication.authenticity_token = page.css('form').css('input')[1]['value']
      unless Authentication.authenticity_token
        fail AuthenticityTokenError, 'Error parsing authenticity_token: Token not found.'
      end
      # Parse sign_in HTML for csrf-token
      page.css('meta').each do |tag|
        Authentication.csrf_token = tag['content'] if tag['name'] == 'csrf-token'
      end
      unless Authentication.csrf_token
        fail CsrfTokenError, 'No csrf-token found'
      end

      # Set cookies for later requests
      Authentication.cookies = sign_in_res.cookies

      # Simulate sign in form submit button.
      body = {'authenticity_token': Authentication.authenticity_token, 'user[email_address]': Authentication.username, 'user[password]': Authentication.password}
      RestClient.post(URL + 'sessions', body, {:cookies => Authentication.cookies}) do |response, request, result, &block|
        # Response should be a 302 redirect from /sessions
        if Request::responseError?(response)
          fail SessionsError, "Error contacting #{URL + 'sessions'}: #{error}"
        end
        # Update cookies just incase
        Authentication.cookies = response.cookies
      end
    end

    # Returns organization_id by parsing existing tickets.
    # At least one ticket MUST exist when this is called.
    def organization_id
      return @organization_id if @organization_id
      tickets = all
      if tickets.empty?
        fail OrganizationIdError, "At least one ticket must exist to parse organization_id."
      end
      @organization_id = tickets.first['organization_id']
    end

    private
    # Returns creator_id for current user from users endpoint
    def creator_id
      unless
        users.each do |user|
          @creator_id = user['id'] if user['email'] == Authentication.username
        end
        unless @creator_id
          fail NoCreatorIdError, "Failed to find creator_id for user: #{Authentication.username}"
        end
      end
      return @creator_id
    end
  end
end
