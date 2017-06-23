require 'singleton'
require File.dirname(__FILE__) + '/organizations'

module HelpDeskAPI
  module Authentication

    # Pass all function calls to Data singleton.
    def self.method_missing(m, *args, &block)
      Data.instance.send(m, *args)
    end

    private
    class Data
      include Singleton

      attr_accessor :username, :password, :authenticity_token, :csrf_token, :cookies

      def initialize
        @username = nil
        @password = nil
        @authenticity_token = nil
        @csrf_token = nil
        @cookies = nil
        @organization_id = nil
        @creator_id = nil
      end

      def signed_in?
        return !@cookies.nil?
      end

      # Returns creator_id for current user from users endpoint
      def creator_id
        return @creator_id if @creator_id

        HelpDeskAPI::Users.users.each do |user|
          if user.email == @username
            @creator_id = user.id
            return @creator_id
          end
        end

        fail NoCreatorIdError, "Failed to find creator_id for user: #{@username}"
      end

      # Returns organization_id or contacts API to get
      # id of first organization.
      def organization_id
        return @organization_id if @organization_id
        @organization_id = HelpDeskAPI::Organizations.organizations.first.id
      end
    end
  end
end
