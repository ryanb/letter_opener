module LetterOpener
  class Configuration
    attr_accessor :location, :message_template, :disable_mail_validation

    def initialize
      @location = Rails.root.join('tmp', 'letter_opener') if defined?(Rails) && Rails.respond_to?(:root)
      @message_template = 'default'
      @disable_mail_validation = false
    end
  end
end
