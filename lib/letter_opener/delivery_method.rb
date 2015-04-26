begin
  require 'mail/check_delivery_params'
rescue LoadError => e
end

module LetterOpener
  class DeliveryMethod
    include Mail::CheckDeliveryParams if defined?(Mail::CheckDeliveryParams)

    class InvalidOption < StandardError; end

    attr_accessor :settings

    def initialize(options = {})
      raise InvalidOption, "A location option is required when using the Letter Opener delivery method" if options[:location].nil?
      self.settings = options
    end

    def deliver!(mail)
      check_delivery_params(mail) if respond_to?(:check_delivery_params)

      location = File.join(settings[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = Message.rendered_messages(location, mail)
      Launchy.open("file:///#{URI.parse(URI.escape(messages.first.filepath))}")
    end
  end
end
