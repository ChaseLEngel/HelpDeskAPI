require File.dirname(__FILE__) + '/request'
require File.dirname(__FILE__) + '/endpoints'
require File.dirname(__FILE__) + '/user'

module HelpDeskAPI
  module Users
    def self.users
      self.parse Request::request('GET', HelpDeskAPI::Endpoints::USERS)
    end

    private
    def self.parse(hash)
      hash['users'].map { |user_hash| User.new.parse(user_hash) }
    end
  end
end
