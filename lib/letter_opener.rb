require "fileutils"
require "digest/sha1"
require "cgi"
require "uri"
require "launchy"

require "letter_opener/message"
require "letter_opener/delivery_method"
if (defined? Rails && Rails.version =~ /^3\./)
	require "letter_opener/railtie" 
elsif defined? Rails
	require "actionmailer/letter_opener_extension"
end
