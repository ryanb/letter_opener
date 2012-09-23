require "spec_helper"

describe LetterOpener::DeliveryMethod do
  before(:each) do
    Launchy.stub(:open)
    location = File.expand_path('../../../tmp/letter_opener', __FILE__)
    FileUtils.rm_rf(location)
    Mail.defaults do
      delivery_method LetterOpener::DeliveryMethod, :location => location
    end
    @location = location
  end

  it "saves text into html document" do
    Launchy.should_receive(:open)
    mail = Mail.deliver do
      from    'Foo foo@example.com'
      to      'bar@example.com'
      subject 'Hello'
      body    'World!'
    end
    text = File.read(Dir["#{@location}/*/plain.html"].first)
    text.should include("Foo foo@example.com")
    text.should include("bar@example.com")
    text.should include("Hello")
    text.should include("World!")
  end

  it "saves multipart email into html document" do
    mail = Mail.deliver do
      from    'foo@example.com'
      to      'bar@example.com'
      subject 'Many parts'
      text_part do
        body 'This is <plain> text'
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body '<h1>This is HTML</h1>'
      end
    end
    text = File.read(Dir["#{@location}/*/plain.html"].first)
    text.should include("View HTML version")
    text.should include("This is &lt;plain&gt; text")
    html = File.read(Dir["#{@location}/*/rich.html"].first)
    html.should include("View plain text version")
    html.should include("<h1>This is HTML</h1>")
  end

  it "saves attachments into a seperate directory" do
    mail = Mail.deliver do
      from      'foo@example.com'
      to        'bar@example.com'
      subject   'With attachments'
      text_part do
        body 'This is <plain> text'
      end
      attachments[File.basename(__FILE__)] = File.read(__FILE__)
    end
    attachment_path = Dir["#{@location}/*/attachments/#{File.basename(__FILE__)}"].first
    File.exists?(attachment_path).should == true
    text = File.read(Dir["#{@location}/*/plain.html"].first)
    text.should include(File.basename(__FILE__))
  end

  it "replaces inline attachment urls" do
    mail = Mail.deliver do
      from      'foo@example.com'
      to        'bar@example.com'
      subject   'With attachments'
      attachments[File.basename(__FILE__)] = File.read(__FILE__)
      url = attachments[0].url
      html_part do
        content_type 'text/html; charset=UTF-8'
        body "Here's an image: <img src='#{url}' />"
      end
    end
    attachment_path = Dir["#{@location}/*/attachments/#{File.basename(__FILE__)}"].first
    File.exists?(attachment_path).should == true
    text = File.read(Dir["#{@location}/*/rich.html"].first)
    mail.parts[0].body.should include(mail.attachments[0].url)
    text.should_not include(mail.attachments[0].url)
    text.should include("attachments/#{File.basename(__FILE__)}")
  end
end

