module LetterOpener
  class DeliveryMethod
    def initialize(options = {})
      @options = {:location => './letter_opener'}.merge!(options)
    end

    def deliver!(mail)
      path = File.join(@options[:location], "#{Time.now.to_i}_#{Digest::SHA1.hexdigest(mail.encoded)[0..6]}.html")
      FileUtils.mkdir_p(@options[:location])
      File.open(path, 'w') do |f|
        template = File.expand_path("../views/index.html.erb", __FILE__)
        f.write ERB.new(File.read(template)).result(binding)
      end
      Launchy.open("file://#{path}")
    end
  end
end
