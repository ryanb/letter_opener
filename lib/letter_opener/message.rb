module LetterOpener
  class Message
    attr_reader :mail

    def initialize(location, mail, part = nil)
      @location = location
      @mail = mail
      @part = part
    end

    def render
      FileUtils.mkdir_p(@location)
      File.open(filepath, 'w') do |f|
        f.write ERB.new(template).result(binding)
      end
    end

    def template
      File.read(File.expand_path("../message.html.erb", __FILE__))
    end

    def filepath
      File.join(@location, "#{type}.html")
    end

    def content_type
      @part && @part.content_type || @mail.content_type
    end

    def body
      (@part && @part.body || @mail.body).to_s
    end

    def type
      content_type =~ /html/ ? "rich" : "plain"
    end
  end
end
