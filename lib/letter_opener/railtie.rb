module LetterOpener
  class Railtie < Rails::Railtie
    initializer "letter_opener.add_delivery_method", before: 'action_mailer.set_configs' do
      ActiveSupport.on_load :action_mailer do
        default_options = {:location => Rails.root.join("tmp", "letter_opener"), :max_msg => nil}
        LetterOpener::DeliveryMethod.default_settings = default_options
        ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, default_options
      end
    end
  end
end
