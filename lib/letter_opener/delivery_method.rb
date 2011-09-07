module LetterOpener
  class DeliveryMethod
    def initialize(options = {})
      @options = {:location => './letter_opener'}.merge!(options)
    end

    def deliver!(mail)
      identity = Time.now.to_i.to_s + Digest::SHA1.hexdigest(mail.encoded)[0..6]
      path = File.join(@options[:location], identity)
      FileUtils.mkdir_p(path)
      File.open(File.join(path, "index.html"), 'w') do |f|
        template = File.expand_path("../views/index.html.erb", __FILE__)
        f.write ERB.new(File.read(template)).result(binding)
      end
    end
  end
end
