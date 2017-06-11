module Helpers
  MissingKey = Class.new(StandardError)
  def self.validateHash(hash, keys)
    keys.each do |key|
      unless hash.has_key? key
        fail MissingKey, "Missing key #{key} in hash:\n#{hash}\n"
      end
    end
  end
end
