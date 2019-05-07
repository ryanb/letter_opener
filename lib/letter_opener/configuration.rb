module LetterOpener
  class Configuration
    attr_accessor :location, :message_template, :launchy

    def initialize
      @location = Rails.root.join('tmp', 'letter_opener') if defined?(Rails) && Rails.respond_to?(:root)
      @message_template = 'default'
      @launchy = true
    end
  end
end
