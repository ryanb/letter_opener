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

  context "saves text into html document" do
    def send_mail
      Mail.deliver do
        from    'Foo foo@example.com'
        to      'bar@example.com'
        subject 'Hello'
        body    'World! http://google.com'
      end
    end
    it "receives open" do
      Launchy.should_receive(:open)
      send_mail
    end
    context 'text' do
      before  { send_mail }
      subject { File.read(Dir["#{@location}/*/plain.html"].first) }
      it { should include("Foo foo@example.com") }
      it { should include("bar@example.com") }
      it { should include("Hello") }
      it { should include("World!") }
      it { should include("<a href=\"http://google.com\">http://google.com</a>") }
    end
  end

  context "saves multipart email into html document" do
    def send_mail
      Mail.deliver do
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
    end
    before { send_mail }
    context 'text' do
      subject { File.read(Dir["#{@location}/*/plain.html"].first) }
      it { should include("View HTML version") }
      it { should include("This is &lt;plain&gt; text") }
    end
    context 'html' do
      subject { File.read(Dir["#{@location}/*/rich.html"].first) }
      it { should include("View plain text version") }
      it { should include("<h1>This is HTML</h1>") }
    end
  end
end

