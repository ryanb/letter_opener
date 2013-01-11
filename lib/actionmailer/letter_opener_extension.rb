# A quick little extension to use this lib with with rails 2.3.X
# To use it, in your environment.rb or some_environment.rb you simply set
#
# config.after_initialize do
#  ActionMailer::Base.delivery_method = :letter_opener
#  ActionMailer::Base.custom_letter_opener_mailer = LetterOpener::DeliveryMethod.new(:location => Rails.root.join("tmp", "letter_opener"))
# end
            
module ActionMailer
  class Base
    cattr_accessor :custom_letter_opener_mailer
    
    def perform_delivery_letter_opener(mail)
      raise 'LetterOpener::DeliveryMethod:InvalidOption has not been intitialized.' unless @@custom_letter_opener_mailer
      @@custom_letter_opener_mailer.deliver!(mail)
    end

  end
end