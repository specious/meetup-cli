lib = File.expand_path '../lib', __FILE__
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'meetup-cli/version'

Gem::Specification.new do |s|
  s.name          = 'meetup-cli'
  s.version       = MCLI::VERSION
  s.licenses      = ['ISC']
  s.summary       = 'Meetup command line interface'
  s.description   = 'A rudimentary command line interface to Meetup.com'
  s.authors       = ['Ildar Sagdejev']
  s.email         = 'specious@gmail.com'
  s.files         = Dir['lib/**/*.rb', 'bin/meetup-cli']
  s.require_paths = ['lib']
  s.executables   = ['meetup-cli']
  s.homepage      = 'https://github.com/specious/meetup-cli'

  s.add_dependency "gli", "= 2.14.0"
  s.add_dependency "rMeetup", "= 2.1.0"
end