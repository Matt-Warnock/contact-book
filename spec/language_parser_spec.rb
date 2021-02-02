# frozen_string_literal: true

require 'language_parser'

RSpec.describe LanguageParser do
  describe '#messages' do
    let(:file) { Tempfile.new(['test', '.yml']) }
    let(:data) do
      {
        string: 'Add another contact? (y/n): ',
        integer: 23,
        hash: { name: 'John', address: 'Westview' }
      }
    end

    before(:each) do
      file.truncate(0)
      file << data.to_yaml
      file.close
    end

    after(:each) { file.unlink }

    it 'raises error if pathname object does not contain a vaild yaml file' do
      language_parser = described_class.new('irelevent.txt')

      expect { language_parser.messages }.to raise_error('Invalid or missing .yml file')
    end

    it 'does not raises error if pathname object contains a vaild yaml' do
      language_parser = described_class.new(file.path)

      expect { language_parser.messages }.not_to raise_error
    end

    it 'parses the yaml file and returns strings' do
      language_parser = described_class.new(file.path)

      expect(language_parser.messages.string).to eq('Add another contact? (y/n): ')
    end

    it 'returns integers' do
      language_parser = described_class.new(file.path)

      expect(language_parser.messages.integer).to eq(23)
    end

    it 'returns hashs' do
      language_parser = described_class.new(file.path)

      expect(language_parser.messages.hash.to_h).to eq({ name: 'John', address: 'Westview' })
    end
  end
end
