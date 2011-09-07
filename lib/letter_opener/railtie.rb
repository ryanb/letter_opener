module LetterOpener
  class Railtie < Rails::Railtie
    initializer "letter_opener.add_delivery_method" do
      ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, :location => Rails.root.join("tmp", "letter_opener")
    end
  end
end
