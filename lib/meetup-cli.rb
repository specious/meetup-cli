require 'gli'
require 'yaml'
require 'colorize'
require 'meetup-cli/api'
require 'meetup-cli/version'

APP_NAME    = File.basename $0, File.extname($0)
CONFIG_FILE = File.join(ENV['HOME'], ".#{APP_NAME}rc")

# Use the GLI command line parser to create this CLI app
#   https://github.com/davetron5000/gli
#
include GLI::App
program_desc "Meetup command line interface"
version MCLI::VERSION
default_command :going
sort_help :manually

switch :color, :desc => 'Force colorized output', :negatable => false

pre do |global_options|
  # Exit without a stack trace when terminating due to a broken pipe
  Signal.trap "PIPE", "SYSTEM_DEFAULT" if Signal.list.include? "PIPE"

  String.disable_colorization(true) unless STDOUT.isatty or global_options['color']

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

def print_event_details(event)
  puts "#{event.name.light_blue}" +
         (/pizza/i.match(event.description) ? " 🍕" : "") +
         (/(beer|drinks)/i.match(event.description) ? " 🍺" : "") +
         (/wine/i.match(event.description) ? " 🍷" : "")
  puts "  #{"URL:".magenta} #{event.event_url}"
  puts "  #{"Date:".magenta} #{date_str(event.time)}"
  puts "  #{"Where:".magenta} #{(event.venue.name.nil? ? "Not specified" : "#{event.venue.address_1}, #{event.venue.city}, #{event.venue.state} (#{event.venue.name.colorize(:green)})")}"
end

def query_events(attendance)
  MCLI::send('get_' + attendance + '_events').each do |event|
    print_event_details event
    puts
  end
end

desc "List upcoming meetups you are going to (default command)"
command :going do |c|
  c.action do
    query_events c.name.to_s
  end
end

desc "List upcoming meetups you are not going to"
command :notgoing do |c|
  c.action do
    query_events c.name.to_s
  end
end

desc "List upcoming meetups you RSVP'ed (yes or no) to"
command :upcoming do |c|
  c.action do
    query_events c.name.to_s
  end
end

desc "List past meetups you went to"
command :went do |c|
  c.action do
    query_events c.name.to_s
  end
end

desc "List past meetups you didn't go to"
command :didntgo do |c|
  c.action do
    query_events c.name.to_s
  end
end

desc "List past meetups you RSVP'ed (yes or no) to"
command :past do |c|
  c.action do
    query_events c.name.to_s
  end
end

exit run(ARGV)