# frozen_string_literal: true

require 'validator'

RSpec.describe Validator do
  let(:validator) { described_class.new }

  describe '#valid_choice?' do
    let(:highest_choice_input) { 4 }

    it 'returns true on avaible choices' do
      result = validator.valid_choice?(highest_choice_input.to_s)

      expect(result).to eq(true)
    end

    it 'returns false on non-avaible choices' do
      non_choice_input = (highest_choice_input + 1).to_s

      result = validator.valid_choice?(non_choice_input)

      expect(result).to eq(false)
    end
  end

  describe '#valid_field?' do
    it 'returns true by defalt on non-specified validation methods' do
      result = validator.valid_field?(:notes, 'I think he has an Oscar')

      expect(result).to eq(true)
    end

    it 'returns true with valid amount of digits' do
      result = validator.valid_field?(:phone, '12345678911')

      expect(result).to eq(true)
    end

    it 'returns false with an invalid amount of digits' do
      result = validator.valid_field?(:phone, '123456')

      expect(result).to eq(false)
    end

    it 'returns true with valid email address' do
      result = validator.valid_field?(:email, 'matt@yahoo.com')

      expect(result).to eq(true)
    end

    it 'returns false with an invalid email address' do
      result = validator.valid_field?(:email, 'matt.yahoo.com')

      expect(result).to eq(false)
    end
  end

  describe '#valid_yes_no_answer?' do
    it 'returns true on a valid yes or no reponse by user' do
      expect(validator.valid_yes_no_answer?(UserInterface::YES_REPLY)).to eq(true)
    end

    it 'returns false on an invalid reponse by user' do
      expect(validator.valid_yes_no_answer?('tomato')).to eq(false)
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
end
