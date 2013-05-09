require 'spec_helper'

describe LetterOpener::Message do
  let(:location) { File.expand_path('../../../tmp/letter_opener', __FILE__) }

  describe '#reply_to' do
    it 'handles one email as a string' do
      message = described_class.new(location, mock(reply_to: 'test@example.com'))
      message.reply_to.should eq('test@example.com')
    end

    it 'handles array of emails' do
      message = described_class.new(location, mock(reply_to: ['test1@example.com', 'test2@example.com']))
      message.reply_to.should eq('test1@example.com, test2@example.com')
    end
  end

  describe '#to' do
    it 'handles one email as a string' do
      message = described_class.new(location, mock(to: 'test@example.com'))
      message.to.should eq('test@example.com')
    end

    it 'handles array of emails' do
      message = described_class.new(location, mock(to: ['test1@example.com', 'test2@example.com']))
      message.to.should eq('test1@example.com, test2@example.com')
    end
  end

  describe '#cc' do
    it 'handles one cc email as a string' do
      message = described_class.new(location, mock(cc: 'test@example.com'))
      message.cc.should eq('test@example.com')
    end

    it 'handles array of cc emails' do
      message = described_class.new(location, mock(cc: ['test1@example.com', 'test2@example.com']))
      message.cc.should eq('test1@example.com, test2@example.com')
    end
  end

  describe '#bcc' do
    it 'handles one bcc email as a string' do
      message = described_class.new(location, mock(bcc: 'test@example.com'))
      message.bcc.should eq('test@example.com')
    end

    it 'handles array of bcc emails' do
      message = described_class.new(location, mock(bcc: ['test1@example.com', 'test2@example.com']))
      message.bcc.should eq('test1@example.com, test2@example.com')
    end
  end

  describe '#sender' do
    it 'handles one email as a string' do
      message = described_class.new(location, mock(sender: 'sender@example.com'))
      message.sender.should eq('sender@example.com')
    end

    it 'handles array of emails' do
      message = described_class.new(location, mock(sender: ['sender1@example.com', 'sender2@example.com']))
      message.sender.should eq('sender1@example.com, sender2@example.com')
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
