# frozen_string_literal: true

require 'controler'
require 'user_interface'

RSpec.describe Controler do
  let(:controler) { described_class.new(ui, [creator, null_action]) }
  let(:creator) { double('Creator', run: nil) }
  let(:exit_input) { StringIO.new('2') }
  let(:null_action) { double('NullAction', run: nil) }
  let(:output) { StringIO.new }
  let(:ui) { UserInterface.new(exit_input, output) }

  it 'tells the user interface to print the menu' do
    controler.start

    expect(output.string).to include(UserInterface::MENU_MESSAGE)
  end

  it 'receives the input from the user interface' do
    ui_double = double('UserInterface', menu_choice: 1)
    controler = described_class.new(ui_double, [creator, null_action])

    controler.start

    expect(ui_double).to have_received(:menu_choice).twice
  end

  it 'runs correct action to perform according to input' do
    controler.start

    expect(null_action).to have_received(:run).once
  end

  it 'prints menu after action is run' do
    add_contact_input = StringIO.new("1\n2")
    ui = UserInterface.new(add_contact_input, output)
    controler = described_class.new(ui, [creator, null_action])

    controler.start

    expect(output.string).to eq(UserInterface::CLEAR_COMMAND +
                                UserInterface::MENU_MESSAGE +
                                UserInterface::CLEAR_COMMAND +
                                UserInterface::MENU_MESSAGE)
  end

  it 'does not print menu again if exit is chosen' do
    controler.start

    expect(output.string).to eq(UserInterface::CLEAR_COMMAND + UserInterface::MENU_MESSAGE)
  end
end
