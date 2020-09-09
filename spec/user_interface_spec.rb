# frozen_string_literal: true

require 'user_interface'

RSpec.describe UserInterface do
  it 'prints menu of options for user to choose' do
    output = StringIO.new
    ui = described_class.new(nil, output)

    ui.run

    expect(output.string).to include(described_class::MENU_MESSAGE)
  end

  it 'Clears the screen before printing the menu' do
    output = StringIO.new
    ui = described_class.new(nil, output)

    ui.run

    expect(output.string).to include("\033[H\033[2J")
  end
end
