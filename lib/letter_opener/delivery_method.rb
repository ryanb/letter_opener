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
    
    DEFAULTS = {
      template: 'default'
    }.freeze

    def initialize(options = {})
      raise InvalidOption, "A location option is required when using the Letter Opener delivery method" if options[:location].nil?
      self.settings = DEFAULTS.merge(options)
    end

    def deliver!(mail)
      check_delivery_params(mail) if respond_to?(:check_delivery_params)

      location = File.join(settings[:location], "#{Time.now.to_f.to_s.tr('.', '_')}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = Message.rendered_messages(location, mail, settings)

      Launchy.open("file:///#{URI.parse(URI.escape(messages.first.filepath))}")
    end
  end
end
