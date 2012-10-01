module LetterOpener
  class DeliveryMethod
    def initialize(options = {})
      self.settings = {:location => './letter_opener'}.merge!(options)
    end

    attr_accessor :settings

    def deliver!(mail)
      location = File.join(settings[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = Message.rendered_messages(location, mail)
      Launchy.open(URI.parse(URI.escape(messages.first.filepath)))
    end
  end
end
