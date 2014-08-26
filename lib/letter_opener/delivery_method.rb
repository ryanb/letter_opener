require 'byebug'

module LetterOpener
  class DeliveryMethod
    class InvalidOption < StandardError; end

    attr_accessor :settings

    def self.default_settings=(settings)
      @@default_settings=settings
    end
    @@default_settings = {}

    def initialize(options = {})
      options = options.merge(@@default_settings||{})
      raise InvalidOption, "A location option is required when using the Letter Opener delivery method" if options[:location].nil?
      raise InvalidOptions "Letter Opener max_rate requires Hash with messages and every keys" if options[:max_rate] &&
        (options[:max_rate][:messages].nil? || options[:max_rate][:every].nil?)
      self.settings = options
    end

    def deliver!(mail)
      location = File.join(settings[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}")
      messages = Message.rendered_messages(location, mail)
      Launchy.open("file:///#{URI.parse(URI.escape(messages.first.filepath))}") unless throttle_send
    end

    def throttle_send
      if self.settings[:max_rate]
        max_msg_count,period = self.settings[:max_rate].values_at(:messages,:every)
        @@sent_times ||= []
        now = Time.now
        @@sent_times = @@sent_times.drop_while {|i| i < now-period }
        return true if @@sent_times.size >= max_msg_count
        @@sent_times.push now
      end
      false
    end
  end
end
