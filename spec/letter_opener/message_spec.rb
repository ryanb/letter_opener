require 'spec_helper'

describe LetterOpener::Message do
  let(:location) { File.expand_path('../../../tmp/letter_opener', __FILE__) }

  def mail(options)
    Mail.new(options)
  end

  describe '#reply_to' do
    it 'handles one email as a string' do
      mail    = mail(:reply_to => 'test@example.com')
      message = described_class.new(location, mail)
      message.reply_to.should eq('test@example.com')
    end

    it 'handles one email with display names' do
      mail    = mail(:reply_to => 'test <test@example.com>')
      message = described_class.new(location, mail)
      message.reply_to.should eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      mail    = mail(:reply_to => ['test1@example.com', 'test2@example.com'])
      message = described_class.new(location, mail)
      message.reply_to.should eq('test1@example.com, test2@example.com')
    end

    it 'handles array of emails with display names' do
      mail    = mail(:reply_to => ['test1 <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      message.reply_to.should eq('test1 <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#to' do
    it 'handles one email as a string' do
      mail   = mail(:to => 'test@example.com')
      message = described_class.new(location, mail)
      message.to.should eq('test@example.com')
    end

    it 'handles one email with display names' do
      mail    = mail(:to => 'test <test@example.com>')
      message = described_class.new(location, mail)
      message.to.should eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      mail    = mail(:to => ['test1@example.com', 'test2@example.com'])
      message = described_class.new(location, mail)
      message.to.should eq('test1@example.com, test2@example.com')
    end

    it 'handles array of emails with display names' do
      mail    = mail(:to => ['test1 <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      message.to.should eq('test1 <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#cc' do
    it 'handles one cc email as a string' do
      mail    = mail(:cc => 'test@example.com')
      message = described_class.new(location, mail)
      message.cc.should eq('test@example.com')
    end

    it 'handles one cc email with display name' do
      mail    = mail(:cc => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      message.cc.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

    it 'handles array of cc emails' do
      mail    = mail(:cc => ['test1@example.com', 'test2@example.com'])
      message = described_class.new(location, mail)
      message.cc.should eq('test1@example.com, test2@example.com')
    end

    it 'handles array of cc emails with display names' do
      mail    = mail(:cc => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      message.cc.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#bcc' do
    it 'handles one bcc email as a string' do
      mail    = mail(:bcc => 'test@example.com')
      message = described_class.new(location, mail)
      message.bcc.should eq('test@example.com')
    end

    it 'handles one bcc email with display name' do
      mail    = mail(:bcc => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      message.bcc.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

    it 'handles array of bcc emails' do
      mail    = mail(:bcc => ['test1@example.com', 'test2@example.com'])
      message = described_class.new(location, mail)
      message.bcc.should eq('test1@example.com, test2@example.com')
    end

    it 'handles array of bcc emails with display names' do
      mail    = mail(:bcc => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      message.bcc.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#sender' do
    it 'handles one email as a string' do
      mail    = mail(:sender => 'sender@example.com')
      message = described_class.new(location, mail)
      message.sender.should eq('sender@example.com')
    end

    it 'handles one email as a string with display name' do
      mail    = mail(:sender => 'test <test@example.com>')
      message = described_class.new(location, mail)
      message.sender.should eq('test <test@example.com>')
    end

    it 'handles array of emails' do
      mail    = mail(:sender => ['sender1@example.com', 'sender2@example.com'])
      message = described_class.new(location, mail)
      message.sender.should eq('sender1@example.com, sender2@example.com')
    end

    it 'handles array of emails with display names' do
      mail    = mail(:sender => ['test <test1@example.com>', 'test2 <test2@example.com>'])
      message = described_class.new(location, mail)
      message.sender.should eq('test <test1@example.com>, test2 <test2@example.com>')
    end

  end

  describe '#<=>' do
    it 'sorts rich type before plain type' do
      plain = described_class.new(location, mock(content_type: 'text/plain'))
      rich  = described_class.new(location, mock(content_type: 'text/html'))
      [plain, rich].sort.should eq([rich, plain])
    end
  end
end
