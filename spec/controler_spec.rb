# frozen_string_literal: true

require 'controler'
require 'null_action'
require 'user_interface'

RSpec.describe Controler do
  let(:actions) { [NullAction.new, NullAction.new] }
  let(:exit_input) { StringIO.new('2') }
  let(:output) { StringIO.new }

  it 'tells the user interface to print the menu' do
    ui = UserInterface.new(exit_input, output)
    controler = described_class.new(ui, actions)

    controler.start

    expect(output.string).to include(UserInterface::MENU_MESSAGE)
  end

  it 'receives the input from the user interface' do
    ui_double = double('UserInterface', menu_choice: 2)
    controler = described_class.new(ui_double, actions)

    controler.start

    expect(ui_double).to have_received(:menu_choice).once
  end

  it 'runs the actions chosen' do
    null_action = double('NullAction', run: nil)
    ui = UserInterface.new(StringIO.new("1\n2"), output)
    controler = described_class.new(ui, [null_action, null_action])

    controler.start

    expect(null_action).to have_received(:run).twice
  end

  it 'prints menu after action is run' do
    null_action = double('NullAction', run: nil)
    add_contact_input = StringIO.new("1\n2")
    ui = UserInterface.new(add_contact_input, output)
    controler = described_class.new(ui, [null_action, null_action])

    controler.start

    expect(output.string.scan(UserInterface::MENU_MESSAGE).length).to eq(2)
  end
end
