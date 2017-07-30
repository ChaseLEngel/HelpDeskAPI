require 'minitest/autorun'

require './lib/helpdeskapi'

class TestTickets < Minitest::Test

  def setup
    username = ENV['HELP_DESK_API_USERNAME']
    password = ENV['HELP_DESK_API_PASSWORD']
    @user_id = ENV['HELP_DESK_API_USER_ID'].to_s

    if username.nil? || password.nil? || @user_id.nil?
      puts "HELP_DESK_API_USERNAME or HELP_DESK_API_PASSWORD or HELP_DESK_API_USER_ID undefinded. Exiting."
      exit
    end

    HelpDeskAPI::Client.new username, password
  end

  def test_ticket_submit
    time = Time.now.to_i.to_s

    ticket = HelpDeskAPI::Ticket.new time, time, @user_id, HelpDeskAPI::Ticket::Priority::LOW
    ticket.submit

    tickets = HelpDeskAPI::Tickets.all

    tickets.keep_if { |t| t.summary == time }
    refute_empty tickets

    assert_equal tickets.first.summary, time
    assert_equal tickets.first.description, time
    assert_equal tickets.first.assignee["id"].to_s, @user_id.to_s
    assert_equal tickets.first.priority, HelpDeskAPI::Ticket::Priority::LOW

  end

  def test_ticket_comment
    time = Time.now.to_i.to_s

    tickets = HelpDeskAPI::Tickets.all
    ticket = tickets.first

    comment = ticket.comment time
    comment.save

    comments = ticket.comments
    refute_empty comments

    comments.keep_if { |c| c.body == time }
    refute_empty comments
  end

  def test_ticket_delete
    tickets = HelpDeskAPI::Tickets.all
    ticket = tickets.first

    ticket.delete

    tickets = HelpDeskAPI::Tickets.all
    tickets.keep_if { |t| t.id == ticket.id }
    assert_empty tickets
  end
end
