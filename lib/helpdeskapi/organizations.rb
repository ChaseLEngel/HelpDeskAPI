require File.dirname(__FILE__) + '/request'
require File.dirname(__FILE__) + '/endpoints'
require File.dirname(__FILE__) + '/utilities'
require File.dirname(__FILE__) + '/organization'

module HelpDeskAPI
  module Organizations
    def self.organizations
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::ORGANIZATIONS), 'organizations', Organization
    end
  end
end
