module LetterOpener
  class DeliveryMethod
    def initialize(options = {})
      @options = {
        :location => './letter_opener',
        :open_all => false
      }.merge!(options)
    end

    def deliver!(mail)
      location = File.join(@options[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = mail.parts.map { |part| Message.new(location, mail, part) }
      messages << Message.new(location, mail) if messages.empty?
      messages.each { |message| message.render }
      
      if @options[:open_all]
        messages.each {|message| open_message(message) }
      else
        open_message(messages.first)
      end
    end

    private

    def open_message(message)
      Launchy.open(URI.parse(message.filepath))
    end
  end
end
