require 'gli'
require 'yaml'
require 'meetup-cli/api'
require 'meetup-cli/version'

APP_NAME    = File.basename $0, File.extname($0)
CONFIG_FILE = File.join(ENV['HOME'], ".#{APP_NAME}rc")

include GLI::App
program_desc "Meetup command line interface"
version MCLI::VERSION
default_command :upcoming

pre do
  # Do not print stack trace when terminating due to a broken pipe
  Signal.trap "SIGPIPE", "SYSTEM_DEFAULT"

  begin
    $config = YAML.load_file(CONFIG_FILE)
    throw if $config['api_key'].nil?
  rescue
    exit_now! <<-EOM
It looks like you are running #{APP_NAME} for the first time.

Obtain an API key from: https://secure.meetup.com/meetup_api/key/

And save the following in ~/.#{APP_NAME}rc:

api_key: <api-key>
EOM
  end

  true # Success
end

on_error do |exception|
  puts exception.message

  # Suppress GLI's built-in error handling
  false
end

# Human friendly date/time in user's time zone (almost RFC 2822)
def date_str(date)
  date.to_time.strftime('%a, %-d %b %Y %H:%M:%S %Z')
end

desc "List your upcoming meetups (default command)"
command :upcoming do |c|
  c.action do
    puts "Your upcoming events:"
    puts "---"
    puts

    MCLI::get_upcoming_events.each do |event|
      puts "#{event.name}"
      puts "  URL: #{event.event_url}"
      puts "  Date: #{date_str(event.time)}"
      puts "  Where: #{event.venue.address_1}, #{event.venue.city}, #{event.venue.state}"
      puts
    end
  end
end

exit run(ARGV)