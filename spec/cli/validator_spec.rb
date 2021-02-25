# frozen_string_literal: true

require 'cli/language_parser'
require 'cli/validator'

RSpec.describe CLI::Validator do
  let(:messages) { CLI::LanguageParser.new('locales/en.yml').messages }
  let(:validator) { described_class.new }

  describe '#valid_choice?' do
    it 'returns true on avaible choices' do
      result = validator.valid_choice?('1', 4)

      expect(result).to eq(true)
    end

    it 'returns false on non-avaible choices' do
      result = validator.valid_choice?('5', 4)

      expect(result).to eq(false)
    end
  end

  describe '#valid_field_value?' do
    it 'returns true by defalt on non-specified validation methods' do
      result = validator.valid_field_value?(:notes, 'I think he has an Oscar')

      expect(result).to eq(true)
    end

    it 'returns true with valid amount of digits' do
      result = validator.valid_field_value?(:phone, '12345678911')

      expect(result).to eq(true)
    end

    it 'returns false with an invalid amount of digits' do
      result = validator.valid_field_value?(:phone, '123456')

      expect(result).to eq(false)
    end

    it 'returns true with valid email address' do
      result = validator.valid_field_value?(:email, 'matt@yahoo.com')

      expect(result).to eq(true)
    end

    it 'returns false with an invalid email address' do
      result = validator.valid_field_value?(:email, 'matt.yahoo.com')

      expect(result).to eq(false)
    end
  end

  describe '#valid_yes_no_answer?' do
    it 'returns true on a valid yes or no reponse by user' do
      result = validator.valid_yes_no_answer?(messages.yes_reply, messages.valid_yes_no_reply)
      expect(result).to eq(true)
    end

    it 'returns false on an invalid reponse by user' do
      result = validator.valid_yes_no_answer?('tomato', messages.valid_yes_no_reply)
      expect(result).to eq(false)
    end
  end

  describe '#valid_string?' do
    it 'returns true on a string with at least one character' do
      expect(validator.valid_string?('Matt Damon')).to eq(true)
    end

    it 'returns false on an empty string' do
      expect(validator.valid_string?('')).to eq(false)
    end
  end

  describe '#valid_index?' do
    it 'returns true on a number less than max number given' do
      expect(validator.valid_index?('2', 3)).to eq(true)
    end

    it 'returns false on a number given that is max number or higher' do
      expect(validator.valid_index?('4', 3)).to eq(false)
    end

    it 'returns false if letter is given' do
      expect(validator.valid_index?('a', 3)).to eq(false)
    end
  end

  describe '#valid_field_name?' do
    it 'returns true on a vaild case insenitive field name spelling' do
      result = validator.valid_field_name?('PHONE', messages.fields_to_display_names.to_h)

      expect(result).to eq(true)
    end

    it 'returns false on incorrect field name spelling' do
      result = validator.valid_field_name?('telephone', messages.fields_to_display_names.to_h)

      expect(result).to eq(false)
    end
  end
end
