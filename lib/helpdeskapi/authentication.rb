require 'singleton'

module Authentication

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
    end

    def signed_in?
      return !@cookies.nil?
    end
  end
end
