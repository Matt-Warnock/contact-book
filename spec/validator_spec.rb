# frozen_string_literal: true

require 'validator'

RSpec.describe Validator do
  describe '#valid_choice?' do
    let(:highest_choice_input) { 2 }
    it 'returns true on avaible choices' do
      validator = described_class.new

      result = validator.valid_choice?(highest_choice_input.to_s)

      expect(result).to eq(true)
    end

    it 'returns false on non-avaible choices' do
      non_choice_input = (highest_choice_input + 1).to_s
      validator = described_class.new

      result = validator.valid_choice?(non_choice_input)

      expect(result).to eq(false)
    end
  end
  describe '#valid_field?' do
    it 'matches field with correct validation method' do
      validator = described_class.new

      result = validator.valid_field?(:phone, '08796564231')

      expect(result).to eq(true)
    end

    it 'returns true by defalt on non-specified validation methods' do
      validator = described_class.new

      result = validator.valid_field?(:notes, 'I think he has an Oscar')

      expect(result).to eq(true)
    end
  end
end
