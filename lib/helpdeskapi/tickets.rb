require File.dirname(__FILE__) + '/request'
require File.dirname(__FILE__) + '/endpoints'
require File.dirname(__FILE__) + '/ticket'
require File.dirname(__FILE__) + '/utilities'

require 'uri'

module HelpDeskAPI
  module Tickets
    def self.search(query)
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS_ALL+"?q=#{URI.escape query}"), 'tickets', Ticket
    end

    def self.all
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS_ALL), 'tickets', Ticket
    end

    def self.open
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS_OPEN), 'tickets', Ticket
    end

    def self.closed
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS_CLOSED), 'tickets', Ticket
    end

    def self.my
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS_MY_TICKETS), 'tickets', Ticket
    end

    def self.unassigned
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS_UNASSIGNED), 'ticket', Ticket
    end

    def self.waiting
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS_WAITING), 'ticket', Ticket
    end

    def self.past_due
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS_PAST_DUE), 'ticket', Ticket
    end
  end
end
