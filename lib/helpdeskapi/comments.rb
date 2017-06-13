require File.dirname(__FILE__) + '/request'
require File.dirname(__FILE__) + '/utilities'

module HelpDeskAPI
  module Comments
    def self.comments(ticket_id)
      HelpDeskAPI::Utilities.parse_response HelpDeskAPI::Request.request('GET', HelpDeskAPI::Endpoints::TICKETS + "/#{ticket_id}/comments"), 'ticket_comments', Comment
    end
  end
end
