module HelpDeskAPI
  module Endpoints
    URL = 'https://on.spiceworks.com'
    SIGN_IN = URL + '/sign_in'
    SESSIONS = URL + '/sessions'

    API_URL = URL + '/api'
    TICKETS = '/tickets'
    TICKETS_OPEN = TICKETS + '/open'
    TICKETS_ALL = TICKETS + '/all'
    TICKETS_CLOSED = TICKETS + '/closed'
    TICKETS_MY_TICKETS = TICKETS + '/my'
    TICKETS_UNASSIGNED = TICKETS + '/unassigned'
    TICKETS_WAITING = TICKETS + '/waiting'
    TICKETS_PAST_DUE = TICKETS + '/past_due'
    USERS = '/users'
    ORGANIZATIONS = '/organizations'
  end
end
