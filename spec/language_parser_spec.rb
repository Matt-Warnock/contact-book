# frozen_string_literal: true

require 'language_parser'

RSpec.describe LanguageParser do
  describe '#messages' do
    let(:file) { Tempfile.new(['test', '.yml']) }
    let(:data) { { prompt: 'Add another contact? (y/n): ' } }

    before(:each) do
      file.truncate(0)
      file << data.to_yaml
      file.close
    end

    after(:each) { file.unlink }

    it 'raises error if pathname object does not contain a vaild yaml file' do
      language_parser = described_class.new(Pathname.new('irelevent.txt'))

      expect { language_parser.messages }.to raise_error('Invalid or missing .yml file')
    end

    it 'does not raises error if pathname object contains a vaild yaml' do
      language_parser = described_class.new(Pathname.new(file))

      expect { language_parser.messages }.not_to raise_error
    end

    it 'parses the yaml file and returns an object representing it' do
      language_parser = described_class.new(Pathname.new(file))

      expect(language_parser.messages[:prompt]).to eq(data[:prompt])
    end
  end
end
