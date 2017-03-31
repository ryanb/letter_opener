require "cgi"
require "erb"
require "fileutils"
require "uri"

module LetterOpener
  class Message
    attr_reader :mail

    def self.rendered_messages(location, mail, settings = {})
      messages = []
      messages << new(location, mail, mail.html_part, settings) if mail.html_part
      messages << new(location, mail, mail.text_part, settings) if mail.text_part
      messages << new(location, mail, nil, settings) if messages.empty?
      messages.each(&:render)
      messages.sort
    end

    def initialize(location, mail, part = nil, settings = {})
      @location = location
      @mail = mail
      @part = part
      @settings = settings
      @attachments = []
    end

    def render
      FileUtils.mkdir_p(@location)

      if mail.attachments.any?
        attachments_dir = File.join(@location, 'attachments')
        FileUtils.mkdir_p(attachments_dir)
        mail.attachments.each do |attachment|
          filename = attachment_filename(attachment)
          path = File.join(attachments_dir, filename)

          unless File.exists?(path) # true if other parts have already been rendered
            File.open(path, 'wb') { |f| f.write(attachment.body.raw_source) }
          end

          @attachments << [attachment.filename, "attachments/#{URI.escape(filename)}"]
        end
      end

      File.open(filepath, 'w') do |f|
        f.write ERB.new(template).result(binding)
      end
    end

    def template
      template = @settings[:template].include?('/') ? @settings[:template] :  File.expand_path("../templates/#{@settings[:template]}.html.erb", __FILE__) 
      File.read(template)
    end

    def filepath
      File.join(@location, "#{type}.html")
    end

    def content_type
      @part && @part.content_type || @mail.content_type
    end

    def body
      @body ||= begin
        body = (@part || @mail).decoded

        mail.attachments.each do |attachment|
          body.gsub!(attachment.url, "attachments/#{attachment_filename(attachment)}")
        end

        body
      end
    end

    def from
      @from ||= Array(@mail['from']).join(", ")
    end

    def sender
      @sender ||= Array(@mail['sender']).join(", ")
    end

    def to
      @to ||= Array(@mail['to']).join(", ")
    end

    def cc
      @cc ||= Array(@mail['cc']).join(", ")
    end

    def bcc
      @bcc ||= Array(@mail['bcc']).join(", ")
    end

    def reply_to
      @reply_to ||= Array(@mail['reply-to']).join(", ")
    end

    def type
      content_type =~ /html/ ? "rich" : "plain"
    end

    def encoding
      body.respond_to?(:encoding) ? body.encoding : "utf-8"
    end

    def auto_link(text)
      text.gsub(URI.regexp(%W[https http])) do |link|
        "<a href=\"#{ link }\">#{ link }</a>"
      end
    end

    def h(content)
      CGI.escapeHTML(content)
    end

    def attachment_filename(attachment)
      attachment.filename.gsub(/[^\w\-_.]/, '_')
    end

    def <=>(other)
      order = %w[rich plain]
      order.index(type) <=> order.index(other.type)
    end
  end
end
