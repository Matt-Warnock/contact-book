# frozen_string_literal: true

require 'validator'

RSpec.describe Validator do
  describe '#valid_choice' do
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
end
