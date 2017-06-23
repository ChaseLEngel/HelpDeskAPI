module HelpDeskAPI
  module Exceptions
    SignInError  = Class.new(StandardError)
    AuthenticityTokenError = Class.new(StandardError)
    CsrfTokenError = Class.new(StandardError)
    SessionsError = Class.new(StandardError)
    NoCreatorIdError = Class.new(StandardError)
    RequestError = Class.new(StandardError)
    MissingKey = Class.new(StandardError)
  end
end
