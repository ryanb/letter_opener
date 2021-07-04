module LetterOpener
  class Configuration
    attr_accessor :location, :message_template, :files_storage

    def initialize
      @location = Rails.root.join('tmp', 'letter_opener') if defined?(Rails) && Rails.respond_to?(:root) && Rails.root
      @message_template = 'default'
      @files_storage = 'file:///'
    end
  end
end
