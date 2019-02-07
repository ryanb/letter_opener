# frozen_string_literal: true

namespace :tmp do
  task clear: ['tmp:letter_opener:clear']

  namespace :letter_opener do
    # desc "Clears all files in tmp/letter_opener"
    task :clear do
      rm_rf Dir['tmp/letter_opener/[^.]*'], verbose: false
    end
  end
end
