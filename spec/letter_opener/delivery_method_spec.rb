require "spec_helper"

describe LetterOpener::DeliveryMethod do
  let(:location) { File.expand_path('../../../tmp/letter_opener', __FILE__) }

  before do
    Launchy.stub(:open)
    FileUtils.rm_rf(location)
    context = self

    Mail.defaults do
      delivery_method LetterOpener::DeliveryMethod, :location => context.location
    end
  end

  it 'raises an exception if no location passed' do
    lambda { LetterOpener::DeliveryMethod.new }.should raise_exception(LetterOpener::DeliveryMethod::InvalidOption)
    lambda { LetterOpener::DeliveryMethod.new(location: "foo") }.should_not raise_exception
  end

  context 'content' do
    let(:plain_file) { Dir["#{location}/*/plain.html"].first }
    let(:plain) { File.read(plain_file) }

    context 'plain' do
      before do
        Launchy.should_receive(:open)

        Mail.deliver do
          from     'Foo foo@example.com'
          reply_to 'No Reply no-reply@example.com'
          to       'Bar bar@example.com'
          subject  'Hello'
          body     'World! http://example.com'
        end
      end

      it 'creates plain html document' do
        File.exist?(plain_file).should be_true
      end

      it 'saves From field' do
        plain.should include("Foo foo@example.com")
      end

      it 'saves Reply-to field' do
        plain.should include("No Reply no-reply@example.com")
      end

      it 'saves To field' do
        plain.should include("Bar bar@example.com")
      end

      it 'saves Subject field' do
        plain.should include("Hello")
      end

      it 'saves Body with autolink' do
        plain.should include('World! <a href="http://example.com">http://example.com</a>')
      end
    end

    context 'multipart' do
      let(:rich_file) { Dir["#{location}/*/rich.html"].first }
      let(:rich) { File.read(rich_file) }

      before do
        Launchy.should_receive(:open)

        Mail.deliver do
          from    'foo@example.com'
          to      'bar@example.com'
          subject 'Many parts with <html>'
          text_part do
            body 'This is <plain> text'
          end
          html_part do
            content_type 'text/html; charset=UTF-8'
            body '<h1>This is HTML</h1>'
          end
        end
      end

      it 'creates plain html document' do
        File.exist?(plain_file).should be_true
      end

      it 'creates rich html document' do
        File.exist?(rich_file).should be_true
      end

      it 'shows link to rich html version' do
        plain.should include("View HTML version")
      end

      it 'saves text part' do
        plain.should include("This is &lt;plain&gt; text")
      end

      it 'saves html part' do
        rich.should include("<h1>This is HTML</h1>")
      end

      it 'saves escaped Subject field' do
        plain.should include("Many parts with &lt;html&gt;")
      end
    end
  end

  context 'document with spaces in name' do
    let(:location) { File.expand_path('../../../tmp/letter_opener with space', __FILE__) }
    let(:file)     { Dir["#{location}/*/plain.html"].first }
    let(:plain)    { File.read(file) }

    before do
      Launchy.should_receive(:open)

      Mail.deliver do
        from     'Foo foo@example.com'
        to       'bar@example.com'
        subject  'Hello'
        body     'World!'
      end
    end

    it 'creates plain html document' do
      File.exist?(file)
    end

    it 'saves From filed' do
      plain.should include("Foo foo@example.com")
    end
  end

  context 'using deliver! method' do
    let(:plain_file) { Dir["#{location}/*/plain.html"].first }
    let(:plain) { File.read(plain_file) }

    before do
      Launchy.should_receive(:open)
      Mail.new do
        from    'foo@example.com'
        to      'bar@example.com'
        subject 'Hello'
        body    'World!'
      end.deliver!
    end

    it 'creates plain html document' do
      File.exist?(plain_file).should be_true
    end

    it 'saves From field' do
      plain.should include("foo@example.com")
    end

    it 'saves To field' do
      plain.should include("bar@example.com")
    end

    it 'saves Subject field' do
      plain.should include("Hello")
    end

    it 'saves Body field' do
      plain.should include("World!")
    end
  end
end
