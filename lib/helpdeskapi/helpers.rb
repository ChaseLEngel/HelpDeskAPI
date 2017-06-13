require 'json'

module HelpDeskAPI
  module Utilities
    MissingKey = Class.new(StandardError)

    def self.validateHash(hash, keys)
      keys.each do |key|
        unless hash.has_key? key
          fail MissingKey, "Missing key #{key} in hash:\n#{hash}\n"
        end
      end
    end

    def self.parse_response(reponse, key, obj)
      hash = JSON.parse response
      hash[key].map { |ticket_hash| obj.new.parse(ticket_hash) }
    end
  end
end
