require 'yaml'
require 'rMeetup'
require 'meetup-cli/version'

APP_NAME    = File.basename $0, File.extname($0)
CONFIG_FILE = File.join(ENV['HOME'], ".#{APP_NAME}rc")

# Convert to human friendly representation in user's time zone (almost RFC 2822)
def date_str(date)
  date.to_time.strftime('%a, %-d %b %Y %H:%M:%S %Z')
end

begin
  $config = YAML.load_file(CONFIG_FILE)
  throw if $config['api_key'].nil?
rescue
  puts <<-EOM
It looks like you are running #{APP_NAME} for the first time.

Obtain an API key from: https://secure.meetup.com/meetup_api/key/

And save the following in ~/.#{APP_NAME}rc:

api_key: <api-key>
  EOM
  exit 0
end

puts "This is #{APP_NAME} #{MCLI::VERSION}"
puts

# Obtain API key: https://secure.meetup.com/meetup_api/key/
client = RMeetup::Client.new do |meetup_config|
  meetup_config.api_key = $config['api_key']
end

puts "Your upcoming events:"
puts

client.fetch(:events, {
    member_id: 'self',
    rsvp: 'yes'
}).each do |res|
  puts "#{res.name}"
  puts "  URL: #{res.event_url}"
  puts "  Date: #{date_str(res.time)}"
  puts "  Where: #{res.venue.address_1}, #{res.venue.city}, #{res.venue.state}"
  puts
end