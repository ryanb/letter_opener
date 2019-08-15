require 'rails/tasks'

namespace :tmp do
  task :letter_opener do
    rm_rf Dir["tmp/letter_opener/[^.]*"], verbose: false
  end
end

Rake::Task['tmp:clear'].enhance(['tmp:letter_opener'])
