Gem::Specification.new do |s|
  s.name        = "letter_opener"
  s.version     = "1.4.1"
  s.author      = "Ryan Bates"
  s.email       = "ryan@railscasts.com"
  s.homepage    = "http://github.com/ryanb/letter_opener"
  s.summary     = "Preview mail in browser instead of sending."
  s.description = "When mail is sent from your application, Letter Opener will open a preview in the browser instead of sending."

  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*"] - ["Gemfile.lock"]
  s.require_path = "lib"

  s.add_dependency 'launchy', '~> 2.2'
  s.add_development_dependency 'rspec', '~> 2.14.0'
  s.add_development_dependency 'mail', '~> 2.6.0'

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
