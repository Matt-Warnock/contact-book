# frozen_string_literal: true

require 'user_interface'

RSpec.describe UserInterface do
  let(:valid_input) { StringIO.new('1') }
  let(:output) { StringIO.new }

  it 'prints menu of options for user to choose' do
    ui = described_class.new(valid_input, output)

    ui.run

    expect(output.string).to include(described_class::MENU_MESSAGE)
  end

  it 'Clears the screen before printing the menu' do
    ui = described_class.new(valid_input, output)

    ui.run

    expect(output.string).to include("\033[H\033[2J")
  end

  it 'reads an input from the user' do
    ui = described_class.new(valid_input, output)

    ui.run

    expect(ui.user_input).to eq('1')
  end
end
