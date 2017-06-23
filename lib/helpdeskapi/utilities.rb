require 'json'

require File.dirname(__FILE__) + '/exceptions'

module HelpDeskAPI
  module Utilities
    # Makes sure all keys exist in hash
    def self.validateHash(hash, keys)
      keys.each do |key|
        unless hash.has_key? key
          fail HelpDeskAPI::Exceptions.MissingKey, "Missing key #{key} in hash:\n#{hash}\n"
        end
      end
    end

    # Converts response to JSON then creates given object and calls parse
    # to handle parsing the response JSON
    def self.parse_response(response, key, obj)
      hash = JSON.parse response
      hash[key].map { |object_hash| obj.new.parse(object_hash) }
    end
  end
end
