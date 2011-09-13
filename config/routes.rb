Rails.application.routes.draw do
  match "/letter_opener"                => 'letter_opener/letters#index', :as => :letter_opener_letters
  match "/letter_opener/:id/:style.html" => 'letter_opener/letters#show', :as => :letter_opener_letter
end
