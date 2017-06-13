require File.dirname(__FILE__) + '/request'
require File.dirname(__FILE__) + '/endpoints'
require File.dirname(__FILE__) + '/user'
require File.dirname(__FILE__) + '/utilities'

module HelpDeskAPI
  module Users
    def self.users
      HelpDeskAPI::Utilities.parse_response Request::request('GET', HelpDeskAPI::Endpoints::USERS), 'users', User
    end

    private
    def self.parse(hash)
      hash['users'].map { |user_hash| User.new.parse(user_hash) }
    end
  end
end
