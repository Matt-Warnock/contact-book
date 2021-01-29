# frozen_string_literal: true

require 'language_parser'

RSpec.describe LanguageParser do
  describe '#language' do
    it 'raises error if pathname object does not contain a vaild .yml with language code' do
      language_parser = described_class.new('irelevent.txt')

      expect { language_parser.language }.to raise_error('Invalid .yml file')
    end

    it 'does not raises error if pathname object contains a vaild .yml' do
      language_parser = described_class.new('en.yml')

      expect { language_parser.language }.not_to raise_error
    end
  end
end
