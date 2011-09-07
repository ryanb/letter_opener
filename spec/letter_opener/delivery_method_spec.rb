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
      from    'foo@example.com'
      to      'bar@example.com'
      subject 'Hello'
      body    'World!'
    end
    html = File.read(Dir["#{@location}/*/index.html"].first)
    html.should include("Hello")
    html.should include("World!")
  end
end
