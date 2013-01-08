require "fileutils"
require "digest/sha1"
require "cgi"
require "uri"
require "launchy"

require "letter_opener/message"
require "letter_opener/delivery_method"
if defined? Rails
	require "letter_opener/railtie" 
	major, minor = Rails.version.split('.')
	require "actionmailer/letter_opener_extension" if major == '2' && minor == '3'
end
