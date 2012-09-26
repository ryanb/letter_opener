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
end
