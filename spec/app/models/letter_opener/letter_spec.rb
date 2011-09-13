require "spec_helper"
require File.expand_path('../../../../../app/models/letter_opener/letter.rb', __FILE__)

describe LetterOpener::Letter do
  let(:location) { File.expand_path('../../../../../tmp/letter_opener/', __FILE__) }
  before(:each) do
    LetterOpener.stub(:letters_location).and_return(location)
    FileUtils.rm_rf(location)
    ['1111_1111', '2222_2222'].each do |folder|
      FileUtils.mkdir_p("#{location}/#{folder}")
      File.open("#{location}/#{folder}/plain.html", 'w') {|f| f.write("I am a plain email for #{folder}") }
      File.open("#{location}/#{folder}/rich.html", 'w') {|f| f.write("I am an <b>html<b> email for #{folder}") }
    end
  end
  describe '.all' do
    let(:all) { LetterOpener::Letter.all }
    describe '2222_2222 is first since it is most recent' do
      subject { all.first }
      its(:name) { should == '2222_2222' }
      its(:contents) { should == 'I am a plain email for 2222_2222' }
      it 'should read the rich contents when requested' do
        subject.contents(:rich) { should == 'I am an <b>html</b> email for 2222_2222' }
      end
      it 'should read the plain contents when requested' do
        subject.contents(:plain) { should == 'I am a text email for 2222_2222' }
      end
    end
    describe '1111_1111 is last since it is oldest' do
      subject { all.last }
      its(:name) { should == '1111_1111' }
      its(:contents) { should == 'I am a plain email for 1111_1111' }
      it 'should read the rich contents when requested' do
        subject.contents(:rich) { should == 'I am an <b>html</b> email for 1111_1111' }
      end
      it 'should read the plain contents when requested' do
        subject.contents(:plain) { should == 'I am a text email for 1111_1111' }
      end
    end
  end

  describe '.find_by_name' do
    subject { LetterOpener::Letter.find_by_name('1111_1111') }
    its(:name) { should == '1111_1111' }
    its(:contents) { should == 'I am a plain email for 1111_1111' }
  end

end
