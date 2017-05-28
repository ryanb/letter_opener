require "digest/sha1"
require "launchy"
begin
  require "mail"
  require "mail/check_delivery_params"
rescue LoadError
end

module LetterOpener
  class DeliveryMethod
    include Mail::CheckDeliveryParams if defined?(Mail::CheckDeliveryParams)

    class InvalidOption < StandardError; end

    attr_accessor :settings

    def initialize(options = {})
      options[:message_template] ||= LetterOpener.configuration.message_template
      options[:location] ||= LetterOpener.configuration.location

      raise InvalidOption, "A location option is required when using the Letter Opener delivery method" if options[:location].nil?

      self.settings = options
    end

    def deliver!(mail)
      check_delivery_params(mail) if respond_to?(:check_delivery_params)
      location = File.join(settings[:location], "#{Time.now.to_f.to_s.tr('.', '_')}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")

      messages = Message.rendered_messages(mail, location: location, message_template: settings[:message_template])
      Launchy.open("file:///#{URI.parse(CGI.escape(messages.first.filepath))}")
    end
  end
end
