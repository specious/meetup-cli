require 'rmeetup'

module MCLI
  def self.init_api
    RMeetup::Client.new do |meetup_config|
      meetup_config.api_key = $config['api_key']
    end
  end

  # Meetup API docs: https://www.meetup.com/meetup_api/docs/2/events/

  def self.get_going_events
    api = init_api.fetch(:events, {member_id: 'self', rsvp: 'yes'})
  end

  def self.get_notgoing_events
    api = init_api.fetch(:events, {member_id: 'self', rsvp: 'no'})
  end

  def self.get_upcoming_events
    api = init_api.fetch(:events, {member_id: 'self'})
  end

  def self.get_went_events
    api = init_api.fetch(:events, {member_id: 'self', status: 'past', desc: 'true', rsvp: 'yes'})
  end

  def self.get_didntgo_events
    api = init_api.fetch(:events, {member_id: 'self', status: 'past', desc: 'true', rsvp: 'no'})
  end

  def self.get_past_events
    # Unlike upcoming events, does not return valid results if 'rsvp' value is not explicitly specified
    api = init_api.fetch(:events, {member_id: 'self', status: 'past', desc: 'true', rsvp: 'yes,no'})
  end
end