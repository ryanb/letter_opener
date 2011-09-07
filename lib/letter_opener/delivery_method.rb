module LetterOpener
  class DeliveryMethod
    def initialize(options = {})
      @options = {:location => './letter_opener'}.merge!(options)
    end

    def deliver!(mail)
      location = File.join(@options[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = mail.parts.map { |part| Message.new(location, mail, part) }
      messages << Message.new(location, mail) if messages.empty?
      messages.each { |message| message.render }
      Launchy.open("file://#{messages.first.filepath}")
    end
  end
end
