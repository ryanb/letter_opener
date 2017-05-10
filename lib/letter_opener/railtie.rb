module LetterOpener
  class Railtie < Rails::Railtie
    initializer "letter_opener.add_delivery_method" do
      ActiveSupport.on_load :action_mailer do
        location = ENV['LETTER_OPENER_LOCATION'] || Rails.root.join("tmp", "letter_opener")
        template = ENV['LETTER_OPENER_MESSAGE_TEMPLATE'] || 'default'
        ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, {location: location, template: template}
      end
    end
  end
end
