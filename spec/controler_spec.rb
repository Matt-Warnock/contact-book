# frozen_string_literal: true

require 'controler'
require 'null_action'

RSpec.describe Controler do
  let(:actions) { [NullAction.new, NullAction.new] }
  let(:exit_choice) { UserInterface::EXIT_CHOICE }
  let(:output) { StringIO.new }

  it 'prints the menu before the action is run and after unless exit is chosen' do
    input = StringIO.new("1\n#{exit_choice}")
    ui = UserInterface.new(input, output)
    controler = described_class.new(ui, actions)

    controler.start

    expect(output.string.scan(UserInterface::MENU_MESSAGE).length).to eq(2)
  end

  it 'receives the input from the user interface' do
    ui_double = double('UserInterface', menu_choice: exit_choice)
    controler = described_class.new(ui_double, actions)

    controler.start

    expect(ui_double).to have_received(:menu_choice).once
  end

  it 'runs the actions chosen' do
    null_action = double('NullAction', run: nil)
    ui = UserInterface.new(StringIO.new("1\n#{exit_choice}"), output)
    controler = described_class.new(ui, [null_action, null_action])

    controler.start

    expect(null_action).to have_received(:run).twice
  end
end
