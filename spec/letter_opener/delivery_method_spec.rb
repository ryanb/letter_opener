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


  it "saves text into html document when deliver! is called" do
    Launchy.should_receive(:open)
    mail = Mail.new do
      from    'foo@example.com'
      to      'bar@example.com'
      subject 'Hello'
      body    'World!'
    end

    mail.deliver!

    text = File.read(Dir["#{@location}/*/plain.html"].first)
    text.should include("foo@example.com")
    text.should include("bar@example.com")
    text.should include("Hello")
    text.should include("World!")
  end
end

