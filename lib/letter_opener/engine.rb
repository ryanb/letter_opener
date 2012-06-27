module LetterOpener
  class Engine < Rails::Engine
    initializer "letter_opener.add_delivery_method" do
      ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, :location => LetterOpener.letters_location
    end
  end

  def self.letters_location
    Rails.root.join("tmp", "letter_opener")
  end
end

