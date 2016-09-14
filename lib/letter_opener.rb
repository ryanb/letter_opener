module LetterOpener
  autoload :Message, "letter_opener/message"
  autoload :DeliveryMethod, "letter_opener/delivery_method"
end

require "letter_opener/railtie" if defined?(Rails::Railtie)
