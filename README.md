Ruby library for Spiceworks Help Desk.

Currently only basic actions have been implemented.

### Installation
```
$ gem build helpdeskapi.gemspec
$ gem install ./HelpDeskAPI-1.0.0.gem
```

Note: Some actions require administrator user
### Signing in
```
HelpDeskAPI::Client.new 'user@example.com', 'password'
```
### Tickets
```
# All tickets
HelpDeskAPI::Tickets.all

# Open tickets
HelpDeskAPI::Tickets.open

# Closed tickets
HelpDeskAPI::Tickets.closed

# My tickets
HelpDeskAPI::Tickets.my

# Unassigned tickets
HelpDeskAPI::Tickets.unassigned

# Waiting tickets
HelpDeskAPI::Tickets.waiting

# Past due tickets
HelpDeskAPI::Tickets.past_due

# Search for a ticket
HelpDeskAPI::Tickets.search 'Summary'

# Ticket creation
ticket = HelpDeskAPI::Ticket.new 'Summary', 'Description', user.id, HelpDeskAPI::Ticket::Priority::HIGH
ticket.submit

# Delete ticket
ticket.delete
```
### Comments
```
# Save comment
comment = ticket.comment 'This is a comment'
comment.save
# or
comment = HelpDeskAPI::Comment.new ticket.id, 'This is a comment'
comment.save

# Get all comment for a ticket
ticket.comments
# or
HelpDeskAPI::Comments.comments ticket.id
```
### Users
```
# Get users (Administrators and Techs)
HelpDeskAPI::Users.users
```
### Organizations
```
# All organizations
HelpDeskAPI::Organizations.organizations
```
