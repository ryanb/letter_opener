require 'spec_helper'

describe LetterOpener::Message do
  let(:location) { File.expand_path('../../../tmp/letter_opener', __FILE__) }

  describe '#reply_to' do
    it 'handles one email as a string' do
      m = Mail.new :reply_to => 'test@example.com'
      message = described_class.new(location, m)
      message.reply_to.should eq('test@example.com')
    end

    it 'handles one email with display names' do
      m = Mail.new :reply_to => 'test <test@example.com>'
      message = described_class.new(location, m)
      message.reply_to.should eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      m = Mail.new :reply_to => ['test1@example.com', 'test2@example.com']
      message = described_class.new(location, m)
      message.reply_to.should eq('test1@example.com, test2@example.com')
    end

    it 'handles array of emails with display names' do
      m = Mail.new :reply_to => ['test1 <test1@example.com>', 'test2 <test2@example.com>']
      message = described_class.new(location, m)
      message.reply_to.should eq('test1 <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#to' do
    it 'handles one email as a string' do
      m = Mail.new :to => 'test@example.com'
      message = described_class.new(location, m)
      message.to.should eq('test@example.com')
    end

    it 'handles one email with display names' do
      m = Mail.new :to => 'test <test@example.com>'
      message = described_class.new(location, m)
      message.to.should eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      m = Mail.new :to => ['test1@example.com', 'test2@example.com']
      message = described_class.new(location, m)
      message.to.should eq('test1@example.com, test2@example.com')
    end

    it 'handles array of emails with display names' do
      m = Mail.new :to => ['test1 <test1@example.com>', 'test2 <test2@example.com>']
      message = described_class.new(location, m)
      message.to.should eq('test1 <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#cc' do
    it 'handles one cc email as a string' do
      m = Mail.new :cc => 'test@example.com'
      message = described_class.new(location, m)
      message.cc.should eq('test@example.com')
    end

    it 'handles one cc email with display name' do
      m = Mail.new :cc => ['test <test1@example.com>', 'test2 <test2@example.com>']
      message = described_class.new(location, m)
      message.cc.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

    it 'handles array of cc emails' do
      m = Mail.new :cc => ['test1@example.com', 'test2@example.com']
      message = described_class.new(location, m)
      message.cc.should eq('test1@example.com, test2@example.com')
    end

    it 'handles array of cc emails with display names' do
      m = Mail.new :cc => ['test <test1@example.com>', 'test2 <test2@example.com>']
      message = described_class.new(location, m)
      message.cc.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#bcc' do
    it 'handles one bcc email as a string' do
      m = Mail.new :bcc => 'test@example.com'
      message = described_class.new(location, m)
      message.bcc.should eq('test@example.com')
    end

    it 'handles one bcc email with display name' do
      m = Mail.new :bcc => ['test <test1@example.com>', 'test2 <test2@example.com>']
      message = described_class.new(location, m)
      message.bcc.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

    it 'handles array of bcc emails' do
      m = Mail.new :bcc => ['test1@example.com', 'test2@example.com']
      message = described_class.new(location, m)
      message.bcc.should eq('test1@example.com, test2@example.com')
    end

    it 'handles array of bcc emails with display names' do
      m = Mail.new :bcc => ['test <test1@example.com>', 'test2 <test2@example.com>']
      message = described_class.new(location, m)
      message.bcc.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#sender' do
    it 'handles one email as a string' do
      m = Mail.new :sender => 'sender@example.com'
      message = described_class.new(location, m)
      message.sender.should eq('sender@example.com')
    end

    it 'handles one email as a string with display name' do
      m = Mail.new :sender => 'test <test@example.com>'
      message = described_class.new(location, m)
      message.sender.should eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      m = Mail.new :sender => ['sender1@example.com', 'sender2@example.com']
      message = described_class.new(location, m)
      message.sender.should eq('sender1@example.com, sender2@example.com')
    end

    it 'handles array of emails with display names' do
      m = Mail.new :sender => ['test <test1@example.com>', 'test2 <test2@example.com>']
      message = described_class.new(location, m)
      message.sender.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#<=>' do
    it 'sorts rich type before plain type' do
      plain = described_class.new(location, mock(content_type: 'text/plain'))
      rich = described_class.new(location, mock(content_type: 'text/html'))
      [plain, rich].sort.should eq([rich, plain])
    end
  end
end
