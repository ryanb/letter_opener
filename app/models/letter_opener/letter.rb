module LetterOpener
  class Letter
    attr_accessor :name, :updated_at
    
    def initialize(attributes)
      @name = attributes[:name]
      @updated_at = attributes[:updated_at]
    end
    
    def self.all
      letters = Dir.glob("#{LetterOpener.letters_location}/*").map do |folder|
        new :name => File.basename(folder), :updated_at => File.mtime(folder)
      end
      letters.sort_by(&:updated_at).reverse
    end
    
    def self.find_by_name(name)
      new(:name => name)
    end
    
    def contents(style = :plain)
      File.read("#{LetterOpener.letters_location}/#{name}/#{style}.html")
    end
  end
end
