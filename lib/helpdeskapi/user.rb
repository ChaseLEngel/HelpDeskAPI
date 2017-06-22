require File.dirname(__FILE__) + '/utilities'
require File.dirname(__FILE__) + '/request'
require File.dirname(__FILE__) + '/authentication'

require 'json'

module HelpDeskAPI
  class User

    module Role
      ADMIN = 'admin'
      TECH = 'tech'
    end

    KEYS = [
      'id',
      'first_name',
      'last_name',
      'email',
      'avatar_url',
      'role',
      'hourly_rate',
      'spiceworks_user_id',
      'wants_alerts',
      'spiceworks_uid',
      'system_user',
      'verified',
      'archived_user_id'
    ]

    def initialize(first_name = nil, last_name = nil, email = nil, hourly_rate = nil)
      @first_name = first_name
      @last_name = last_name
      @email = email
      @hourly_rate = hourly_rate
    end

    def edit(hash)
      editable = ['first_name', 'last_name', 'email', 'wants_alerts', 'hourly_rate']
      hash.keep_if { |key, _| editable.include? key.to_s }
      JSON.generate(
        {
          user: {
            account_id: nil,
            archived_user_id: @archived_user_id,
            avatar_url: @avatar_url,
            deleted: @deleted,
            email: @email,
            first_name: @first_name,
            hourly_rate: @hourly_rate,
            last_name: @last_name,
            owned_account_id: nil,
            role: @role,
            spiceworks_uid: @spiceworks_uid,
            spiceworks_user_id: @spiceworks_user_id,
            system_user: @system_user,
            verified: @verified,
            wants_alerts: @wants_alerts
          }
        })
      return # Missing account_id
      headers = {'authenticity_token': HelpDeskAPI::Authentication.authenticity_token, 'X-CSRF-Token': HelpDeskAPI::Authentication.csrf_token, 'Content-Type': 'application/json'}
      HelpDeskAPI::Request.request('PUT', Endpoints::USERS + "/#{@id}", payload, headers)
    end

    def save
    end

    def parse(user_hash)
      HelpDeskAPI::Utilities.validateHash(user_hash, KEYS)
      KEYS.each do |key|
        instance_variable_set '@'+key, user_hash[key]
        self.class.class_eval { attr_accessor key }
      end
      return self
    end
  end
end
