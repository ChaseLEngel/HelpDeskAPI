require 'json'

module HelpDeskAPI
  class Comment

    KEYS = [
      'id',
      'activity_type',
      'created_at',
      'body',
      'attachment_ids',
      'ticket',
      'creator',
    ]

    def initialize(ticket_id = nil, body = nil)
      @ticket_id = ticket_id
      @body = body
    end

    def parse(comment_hash)
      HelpDeskAPI::Utilities.validateHash(comment_hash, KEYS)
      KEYS.each do |key|
        instance_variable_set '@'+key, comment_hash[key]
        self.class.class_eval { attr_accessor key }
      end
      return self
    end

    def save
      payload = JSON.generate(
        {
          comment: {
            activity_type: 'comment',
            body: @body,
            created_at: nil,
            creator_id: nil,
            creator_type: nil,
            ticket_id: @ticket_id
          },
          ticket_comment: {
            activity_type: 'comment',
            body: @body,
            created_at: nil,
            creator_id: nil,
            creator_type: nil,
            initial_upload_ids: [],
            ticket_id: @ticket_id
          }
        })
      headers = {'authenticity_token': Authentication.authenticity_token, 'X-CSRF-Token': Authentication.csrf_token, 'Content-Type': 'application/json'}
      response = HelpDeskAPI::Request.request('POST', Endpoints::TICKETS + "/#{@ticket_id}" + '/comments', payload, headers)
      parse JSON.parse(response)['comment']
    end
  end
end
