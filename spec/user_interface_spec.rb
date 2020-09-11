# frozen_string_literal: true

require 'user_interface'

RSpec.describe UserInterface do
  let(:output) { StringIO.new }
  let(:valid_input) { StringIO.new('1') }

  it 'Prints menu of options for user to choose' do
    ui = described_class.new(valid_input, output)

    ui.run

    expect(output.string).to include(described_class::MENU_MESSAGE)
  end

  it 'Clears the screen before printing the menu' do
    ui = described_class.new(valid_input, output)

    ui.run

    expect(output.string).to include("\033[H\033[2J")
  end

  it 'Reads an input from the user' do
    ui = described_class.new(valid_input, output)

    ui.run

    expect(ui.user_input).to eq('1')
  end

  it 'Validates input, numbers only' do
    input = StringIO.new("a\n1\n")
    ui = described_class.new(input, output)

    ui.run

    expect(output.string).to include(described_class::ERROR_MESSAGE)
  end

  it 'Validates input, only if number is 1' do
    input = StringIO.new("2\n1\n")
    ui = described_class.new(input, output)

    ui.run

    expect(output.string).to include(described_class::ERROR_MESSAGE)
  end

  it 'Reads the input again if input is invalid' do
    input = StringIO.new("yes\n1\n")
    ui = described_class.new(input, output)

    ui.run

    expect(ui.user_input).to eq('1')
  end

  it 'Returns a valid input' do
    input = StringIO.new('1')
    ui = described_class.new(input, output)

    expect(ui.run).to eq('1')
  end
end
