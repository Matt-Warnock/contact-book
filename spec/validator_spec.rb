# frozen_string_literal: true

require 'validator'

RSpec.describe Validator do
  let(:validator) { described_class.new }
  describe '#valid_choice?' do
    let(:highest_choice_input) { 2 }
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
    it 'matches field with correct validation method' do
      result = validator.valid_field?(:phone, '08796564231')

      expect(result).to eq(true)
    end

    it 'returns true by defalt on non-specified validation methods' do
      result = validator.valid_field?(:notes, 'I think he has an Oscar')

      expect(result).to eq(true)
    end
  end
  describe '#valid_phone?' do
    it 'returns true with valid amount of digits' do
      expect(validator.valid_phone?('12345678911')).to eq(true)
    end

    it 'returns false with an invalid amount of digits' do
      expect(validator.valid_phone?('123456')).to eq(false)
    end
  end

  describe '#valid_email?' do
    it 'returns true with valid email address' do
      expect(validator.valid_email?('matt@yahoo.com')).to eq(true)
    end

    it 'returns false with an invalid email address' do
      expect(validator.valid_email?('matt.yahoo.com')).to eq(false)
    end
  end

  describe '#valid_yes_no_answer?' do
    it 'returns true on a valid yes or no reponse by user' do
      expect(validator.valid_yes_no_answer?('y')).to eq(true)
    end

    it 'returns false on an invalid reponse by user' do
      expect(validator.valid_yes_no_answer?('tomato')).to eq(false)
    end
  end
end
