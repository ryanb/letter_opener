require 'spec_helper'

describe LetterOpener::Message do
  let(:location) { File.expand_path('../../../tmp/letter_opener', __FILE__) }

  def mail(options={})
    Mail.new(options)
  end

  describe '#reply_to' do
    it 'handles one email as a string' do
      mail    = mail(:reply_to => 'test@example.com')
      message = described_class.new(location, mail)
      expect(message.reply_to).to eq('test@example.com')
    end

    it 'handles one email with display names' do
      mail    = mail(:reply_to => 'test <test@example.com>')
      message = described_class.new(location, mail)
      expect(message.reply_to).to eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      mail    = mail(:reply_to => ['test1@example.com', 'test2@example.com'])
      message = described_class.new(location, mail)
      expect(message.reply_to).to eq('test1@example.com, test2@example.com')
    end

    it 'handles array of emails with display names' do
      mail    = mail(:reply_to => ['test1 <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      expect(message.reply_to).to eq('test1 <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#to' do
    it 'handles one email as a string' do
      mail   = mail(:to => 'test@example.com')
      message = described_class.new(location, mail)
      expect(message.to).to eq('test@example.com')
    end

    it 'handles one email with display names' do
      mail    = mail(:to => 'test <test@example.com>')
      message = described_class.new(location, mail)
      expect(message.to).to eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      mail    = mail(:to => ['test1@example.com', 'test2@example.com'])
      message = described_class.new(location, mail)
      expect(message.to).to eq('test1@example.com, test2@example.com')
    end

    it 'handles array of emails with display names' do
      mail    = mail(:to => ['test1 <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      expect(message.to).to eq('test1 <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#cc' do
    it 'handles one cc email as a string' do
      mail    = mail(:cc => 'test@example.com')
      message = described_class.new(location, mail)
      expect(message.cc).to eq('test@example.com')
    end

    it 'handles one cc email with display name' do
      mail    = mail(:cc => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      expect(message.cc).to eq('test <test1@example.com>, test2 <test2@example.com>')
    end

    it 'handles array of cc emails' do
      mail    = mail(:cc => ['test1@example.com', 'test2@example.com'])
      message = described_class.new(location, mail)
      expect(message.cc).to eq('test1@example.com, test2@example.com')
    end

    it 'handles array of cc emails with display names' do
      mail    = mail(:cc => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      expect(message.cc).to eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#bcc' do
    it 'handles one bcc email as a string' do
      mail    = mail(:bcc => 'test@example.com')
      message = described_class.new(location, mail)
      expect(message.bcc).to eq('test@example.com')
    end

    it 'handles one bcc email with display name' do
      mail    = mail(:bcc => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      expect(message.bcc).to eq('test <test1@example.com>, test2 <test2@example.com>')
    end

    it 'handles array of bcc emails' do
      mail    = mail(:bcc => ['test1@example.com', 'test2@example.com'])
      message = described_class.new(location, mail)
      expect(message.bcc).to eq('test1@example.com, test2@example.com')
    end

    it 'handles array of bcc emails with display names' do
      mail    = mail(:bcc => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      expect(message.bcc).to eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#sender' do
    it 'handles one email as a string' do
      mail    = mail(:sender => 'sender@example.com')
      message = described_class.new(location, mail)
      expect(message.sender).to eq('sender@example.com')
    end

    it 'handles one email as a string with display name' do
      mail    = mail(:sender => 'test <test@example.com>')
      message = described_class.new(location, mail)
      expect(message.sender).to eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      mail    = mail(:sender => ['sender1@example.com', 'sender2@example.com'])
      message = described_class.new(location, mail)
      expect(message.sender).to eq('sender1@example.com, sender2@example.com')
    end

    it 'handles array of emails with display names' do
      mail    = mail(:sender => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      expect(message.sender).to eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#<=>' do
    it 'sorts rich type before plain type' do
      plain = described_class.new(location, double(content_type: 'text/plain'))
      rich  = described_class.new(location, double(content_type: 'text/html'))
      expect([plain, rich].sort).to eq([rich, plain])
    end
  end

  describe '#auto_link' do
    let(:message){ described_class.new(location, mail) }

    it 'should not modify unlinkable text' do
      text = 'the quick brown fox jumped over the lazy dog'
      expect(message.auto_link(text)).to eq(text)
    end

    it 'should add links for http' do
      raw = "Link to http://localhost:3000/example/path path"
      linked = "Link to <a href=\"http://localhost:3000/example/path\">http://localhost:3000/example/path</a> path"
      expect(message.auto_link(raw)).to eq(linked)
    end
  end
end
