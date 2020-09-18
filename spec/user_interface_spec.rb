# frozen_string_literal: true

require 'user_interface'

RSpec.describe UserInterface do
  let(:error_message) { described_class::ERROR_MESSAGE }
  let(:output) { StringIO.new }
  let(:valid_input) { StringIO.new('1') }

  it 'prints menu of options for user to choose' do
    ui = described_class.new(valid_input, output)

    ui.run

    expect(output.string).to include(described_class::MENU_MESSAGE)
  end

  it 'clears the screen before printing the menu' do
    ui = described_class.new(valid_input, output)

    ui.run

    expect(output.string).to include("\033[H\033[2J" + described_class::MENU_MESSAGE)
  end

  it 'reads an input from the user' do
    ui = described_class.new(valid_input, output)

    user_input = ui.run

    expect(user_input).to eq(1)
  end

  it 'validates input, numbers only' do
    input = StringIO.new("a\n1\n")
    ui = described_class.new(input, output)

    ui.run

    expect(output.string).to include(error_message)
  end

  it 'validates input, only if number is 1' do
    input = StringIO.new("2\n1\n")
    ui = described_class.new(input, output)

    ui.run

    expect(output.string).to include(error_message)
  end

  it 'reads the input again if input is invalid' do
    input = StringIO.new("yes\n1\n")
    ui = described_class.new(input, output)

    user_input = ui.run

    expect(user_input).to eq(1)
  end

  it 'repeats printing error message untill valid input is entered' do
    input = StringIO.new("yes\n0\n5\n1\n")
    ui = described_class.new(input, output)

    ui.run

    expect(output.string.scan(error_message).length).to eq(3)
  end

  it 'returns a valid input' do
    ui = described_class.new(valid_input, output)

    expect(ui.run).to eq(1)
  end

  describe 'ask for fields method' do
    let(:input) { StringIO.new(contact_input) }
    let(:ui) { described_class.new(input, output) }

    it 'asks user for contact name' do
      ui.ask_for_fields

      expect(output.string).to include(described_class::FIELDS_TO_PROMPTS[:name])
    end

    it 'reads the input for contact name' do
      user_input = ui.ask_for_fields

      expect(user_input[:name]).to include(TEST_DETAILS[:name])
    end

    it 'asks user for adress' do
      ui.ask_for_fields

      expect(output.string).to include(described_class::FIELDS_TO_PROMPTS[:address])
    end

    it 'reads the input for contact address' do
      user_input = ui.ask_for_fields

      expect(user_input[:address]).to include(TEST_DETAILS[:address])
    end
  end

  TEST_DETAILS = {
    name: 'Matt Damon',
    address: 'Some address'
  }.freeze

  def contact_input
    TEST_DETAILS.values.join("\n")
  end
end
