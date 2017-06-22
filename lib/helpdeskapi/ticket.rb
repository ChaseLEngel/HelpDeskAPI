require File.dirname(__FILE__) + '/endpoints'
require File.dirname(__FILE__) + '/utilities'
require File.dirname(__FILE__) + '/request'
require File.dirname(__FILE__) + '/comment'
require File.dirname(__FILE__) + '/comments'

module HelpDeskAPI
  class Ticket

    module Priority
      HIGH = '1'
      MEDIUM = '2'
      LOW = '3'
    end

    KEYS = [
      'id',
      'created_at',
      'creator',
      'description',
      'due_at',
      'organization_id',
      'priority',
      'status',
      'summary',
      'updated_at',
      'custom_values',
      'assignee',
      'ticket_category',
    ]

    def initialize(summary = nil, description = nil, assignee_id = nil, priority = nil)
      @summary = summary
      @description = description
      @assignee_id = assignee_id
      @priority = priority
    end

    def parse(ticket_hash)
      HelpDeskAPI::Utilities.validateHash(ticket_hash, KEYS)
      KEYS.each do |key|
        instance_variable_set '@'+key, ticket_hash[key]
        self.class.class_eval { attr_accessor key }
      end
      return self
    end

    def submit
      payload = JSON.generate({
          ticket: {
            summary: @summary,
            description: @description,
            priority: @priority,
            due_at: nil,
            updated_at: nil,
            created_at: nil,
            organization_id: HelpDeskAPI::Authentication.organization_id,
            assignee_id: @assignee_id,
            assignee_type: 'User',
            creator_id: HelpDeskAPI::Authentication.creator_id,
            creator_type: 'User',
            custom_values: [],
            ticket_category_id: nil,
            ticket_category_type: nil,
            watchers: []
          }
        })
      headers = {'authenticity_token': HelpDeskAPI::Authentication.authenticity_token, 'X-CSRF-Token': HelpDeskAPI::Authentication.csrf_token, 'Content-Type': 'application/json'}
      response = HelpDeskAPI::Request.request('POST', Endpoints::TICKETS, payload, headers)
      parse JSON.parse(response)['tickets'].first
    end

    def close
    end

    def reopen
    end

    def delete
      headers = {'authenticity_token': HelpDeskAPI::Authentication.authenticity_token, 'X-CSRF-Token': HelpDeskAPI::Authentication.csrf_token, 'Content-Type': 'application/json'}
      HelpDeskAPI::Request.request('DELETE', Endpoints::TICKETS + "/#{@id}", nil, headers)
    end

    def comments
      HelpDeskAPI::Comments.comments @id
    end

    def comment(body)
      HelpDeskAPI::Comment.new @id, body
    end
  end
end
