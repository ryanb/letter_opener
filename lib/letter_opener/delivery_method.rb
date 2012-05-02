module LetterOpener
  class DeliveryMethod
    def initialize(options = {})
      @options = { :location => defined?(Rails) ? Rails.root.join("tmp", "letter_opener") : './letter_opener' }.merge(options)
    end

    def deliver!(mail)
      location = File.join(@options[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = mail.parts.map { |part| Message.new(location, mail, part) }
      messages << Message.new(location, mail) if messages.empty?
      messages.each { |message| message.render }
      Launchy.open(URI.parse("file://#{messages.first.filepath}"))
    end
  end
end
