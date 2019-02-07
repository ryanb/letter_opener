module LetterOpener
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/tmp.rake', __dir__)
    end

    initializer "letter_opener.add_delivery_method" do
      ActiveSupport.on_load :action_mailer do
        ActionMailer::Base.add_delivery_method(
          :letter_opener,
          LetterOpener::DeliveryMethod
        )
      end
    end
  end
end
