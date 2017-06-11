require File.dirname(__FILE__) + '/request'
require File.dirname(__FILE__) + '/endpoints'
require File.dirname(__FILE__) + '/ticket'

module HelpDeskAPI
  module Tickets
    def self.search(query)
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::TICKETS_ALL+"?q=#{query}")
    end

    def self.all
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::TICKETS_ALL)
    end

    def self.open
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::TICKETS_OPEN)
    end

    def self.closed
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::TICKETS_CLOSED)
    end

    def self.my
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::TICKETS_MY_TICKETS)
    end

    def self.unassigned
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::TICKETS_UNASSIGNED)
    end

    def self.waiting
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::TICKETS_WAITING)
    end

    def self.past_due
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::TICKETS_PAST_DUE)
    end

    private
    def self.parse(hash)
      hash['tickets'].map { |ticket_hash| Ticket.new.parse(ticket_hash) }
    end
  end
end
