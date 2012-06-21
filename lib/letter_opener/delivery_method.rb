module LetterOpener
  class DeliveryMethod
    def initialize(options = {})
      self.settings = {:location => './letter_opener'}.merge!(options)
    end

    attr_accessor :settings

    def deliver!(mail)
      location = File.join(settings[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = mail.parts.map { |part| Message.new(location, mail, part) }
      messages << Message.new(location, mail) if messages.empty?
      messages.each { |message| message.render }
      initial_message = messages.find { |msg| msg.type == 'rich' } || messages.first
      Launchy.open(URI.parse("file://#{initial_message.filepath}"))
    end
  end
end
