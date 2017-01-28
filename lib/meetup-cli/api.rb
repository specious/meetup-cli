require 'rmeetup'

module MCLI
  def self.init_api
    RMeetup::Client.new do |meetup_config|
      meetup_config.api_key = $config['api_key']
    end
  end

  def self.get_upcoming_events
    api = init_api.fetch(:events, {member_id: 'self', rsvp: 'yes'})
  end
end