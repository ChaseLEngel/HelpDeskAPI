require File.dirname(__FILE__) + '/utilities'
require File.dirname(__FILE__) + '/request'

module HelpDeskAPI
  class User
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

    def save
    end

    def parse(user_hash)
      Helpers::validateHash(user_hash, KEYS)
      KEYS.each do |key|
        instance_variable_set '@'+key, user_hash[key]
        self.class.class_eval { attr_accessor key }
      end
      return self
    end
  end
end
