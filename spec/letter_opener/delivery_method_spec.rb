require "spec_helper"

describe LetterOpener::DeliveryMethod do
  let(:location)   { File.expand_path('../../../tmp/letter_opener', __FILE__) }

  let(:plain_file) { Dir["#{location}/*/plain.html"].first }
  let(:plain)      { CGI.unescape_html(File.read(plain_file)) }

  before do
    Launchy.stub(:open)
    FileUtils.rm_rf(location)
    context = self

    Mail.defaults do
      delivery_method LetterOpener::DeliveryMethod, :location => context.location
    end
  end

  it 'raises an exception if no location passed' do
    expect { LetterOpener::DeliveryMethod.new }.to raise_exception(LetterOpener::DeliveryMethod::InvalidOption)
    expect { LetterOpener::DeliveryMethod.new(location: "foo") }.to_not raise_exception
  end

  context 'integration' do
    before do
      Launchy.unstub(:open)
      ENV['LAUNCHY_DRY_RUN'] = 'true'
    end

    context 'normal location path' do
      it 'opens email' do
        expect($stdout).to receive(:puts)
        expect {
          Mail.deliver do
            to   'Bar bar@example.com'
            from 'Foo foo@example.com'
            body 'World! http://example.com'
          end
        }.not_to raise_error
      end
    end

    context 'with spaces in location path' do
      let(:location) { File.expand_path('../../../tmp/letter_opener with space', __FILE__) }

      it 'opens email' do
        expect($stdout).to receive(:puts)
        expect {
          Mail.deliver do
            to   'Bar bar@example.com'
            from 'Foo foo@example.com'
            body 'World! http://example.com'
          end
        }.not_to raise_error
      end
    end
  end

  context 'content' do
    context 'plain' do
      before do
        expect(Launchy).to receive(:open)

        Mail.deliver do
          from     'Foo <foo@example.com>'
          sender   'Baz <baz@example.com>'
          reply_to 'No Reply <no-reply@example.com>'
          to       'Bar <bar@example.com>'
          cc       'Qux <qux@example.com>'
          bcc      'Qux <qux@example.com>'
          subject  'Hello'
          body     'World! http://example.com'
        end
      end

      it 'creates plain html document' do
        expect(File.exist?(plain_file)).to be_true
      end

      it 'saves From field' do
        expect(plain).to include("Foo <foo@example.com>")
      end

      it 'saves Sender field' do
        expect(plain).to include("Baz <baz@example.com>")
      end

      it 'saves Reply-to field' do
        expect(plain).to include("No Reply <no-reply@example.com>")
      end

      it 'saves To field' do
        expect(plain).to include("Bar <bar@example.com>")
      end

      it 'saves Subject field' do
        expect(plain).to include("Hello")
      end

      it 'saves Body with autolink' do
        expect(plain).to include('World! <a href="http://example.com">http://example.com</a>')
      end
    end

    context 'multipart' do
      let(:rich_file) { Dir["#{location}/*/rich.html"].first }
      let(:rich) { CGI.unescape_html(File.read(rich_file)) }

      before do
        expect(Launchy).to receive(:open)

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
        expect(File.exist?(plain_file)).to be_true
      end

      it 'creates rich html document' do
        expect(File.exist?(rich_file)).to be_true
      end

      it 'shows link to rich html version' do
        expect(plain).to include("View HTML version")
      end

      it 'saves text part' do
        expect(plain).to include("This is <plain> text")
      end

      it 'saves html part' do
        expect(rich).to include("<h1>This is HTML</h1>")
      end

      it 'saves escaped Subject field' do
        expect(plain).to include("Many parts with <html>")
      end

      it 'shows subject as title' do
        expect(rich).to include("<title>Many parts with <html></title>")
      end
    end
  end

  context 'document with spaces in name' do
    let(:location) { File.expand_path('../../../tmp/letter_opener with space', __FILE__) }

    before do
      expect(Launchy).to receive(:open)

      Mail.deliver do
        from     'Foo <foo@example.com>'
        to       'bar@example.com'
        subject  'Hello'
        body     'World!'
      end
    end

    it 'creates plain html document' do
      File.exist?(plain_file)
    end

    it 'saves From filed' do
      expect(plain).to include("Foo <foo@example.com>")
    end
  end

  context 'using deliver! method' do
    before do
      expect(Launchy).to receive(:open)
      Mail.new do
        from    'foo@example.com'
        to      'bar@example.com'
        subject 'Hello'
        body    'World!'
      end.deliver!
    end

    it 'creates plain html document' do
      expect(File.exist?(plain_file)).to be_true
    end

    it 'saves From field' do
      expect(plain).to include("foo@example.com")
    end

    it 'saves To field' do
      expect(plain).to include("bar@example.com")
    end

    it 'saves Subject field' do
      expect(plain).to include("Hello")
    end

    it 'saves Body field' do
      expect(plain).to include("World!")
    end
  end

  context 'attachments in plain text mail' do
    before do
      Mail.deliver do
        from      'foo@example.com'
        to        'bar@example.com'
        subject   'With attachments'
        text_part do
          body 'This is <plain> text'
        end
        attachments[File.basename(__FILE__)] = File.read(__FILE__)
      end
    end

    it 'creates attachments dir with attachment' do
      attachment = Dir["#{location}/*/attachments/#{File.basename(__FILE__)}"].first
      expect(File.exists?(attachment)).to be_true
    end

    it 'saves attachment name' do
      plain = File.read(Dir["#{location}/*/plain.html"].first)
      expect(plain).to include(File.basename(__FILE__))
    end
  end

  context 'attachments in rich mail' do
    let(:url) { mail.attachments[0].url }

    let!(:mail) do
      Mail.deliver do
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
    end

    it 'creates attachments dir with attachment' do
      attachment = Dir["#{location}/*/attachments/#{File.basename(__FILE__)}"].first
      expect(File.exists?(attachment)).to be_true
    end

    it 'replaces inline attachment urls' do
      text = File.read(Dir["#{location}/*/rich.html"].first)
      expect(mail.parts[0].body).to include(url)
      expect(text).to_not include(url)
      expect(text).to include("attachments/#{File.basename(__FILE__)}")
    end
  end

  context 'attachments with non-word characters in the filename' do
    before do
      Mail.deliver do
        from      'foo@example.com'
        to        'bar@example.com'
        subject   'With attachments'
        text_part do
          body 'This is <plain> text'
        end
        attachments['non word:chars/used,01.txt'] = File.read(__FILE__)
      end
    end

    it 'creates attachments dir with attachment' do
      attachment = Dir["#{location}/*/attachments/non_word_chars_used_01.txt"].first
      expect(File.exists?(attachment)).to be_true
    end

    it 'saves attachment name' do
      plain = File.read(Dir["#{location}/*/plain.html"].first)
      expect(plain).to include('non_word_chars_used_01.txt')
    end
  end

  context 'subjectless mail' do
    before do
      expect(Launchy).to receive(:open)

      Mail.deliver do
        from     'Foo foo@example.com'
        reply_to 'No Reply no-reply@example.com'
        to       'Bar bar@example.com'
        body     'World! http://example.com'
      end
    end

    it 'creates plain html document' do
      expect(File.exist?(plain_file)).to be_true
    end
  end

  context 'delivery params' do
    it 'raises an exception if delivery params are not valid' do
      expect(Launchy).not_to receive(:open)

      expect {
        Mail.deliver do
          from     'Foo foo@example.com'
          reply_to 'No Reply no-reply@example.com'
          body     'World! http://example.com'
        end
      }.to raise_exception(ArgumentError)
    end
  end
end
