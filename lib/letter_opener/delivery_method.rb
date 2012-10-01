module LetterOpener
  class DeliveryMethod
    class InvalidOption < StandardError; end

    attr_accessor :settings

    def initialize(options = {})
      raise InvalidOption, "A location option is required when using the Letter Opener delivery method" if options[:location].nil?
      self.settings = options
    end

    def deliver!(mail)
      location = File.join(settings[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = Message.rendered_messages(location, mail)
      Launchy.open(URI.parse(URI.escape(messages.first.filepath)))
    end
  end
end
