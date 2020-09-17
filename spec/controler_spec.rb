# frozen_string_literal: true

require 'controler'
require 'user_interface'
require 'null_action'

RSpec.describe Controler do
  let(:actions) { [NullAction.new] }
  let(:output) { StringIO.new }
  let(:valid_input) { StringIO.new('1') }

  it 'tells the user interface to print the menu' do
    ui = UserInterface.new(valid_input, output)
    controler = Controler.new(ui, actions)

    controler.start

    expect(output.string).to include(UserInterface::MENU_MESSAGE)
  end

  it 'receives the input from the user interface' do
    ui_double = double('UserInterface', run: 1)
    controler = Controler.new(ui_double, actions)

    controler.start

    expect(ui_double).to have_received(:run).once
  end

  it 'selects correct action to perform according to input' do
    ui = UserInterface.new(valid_input, output)
    controler = Controler.new(ui, actions)

    expect(controler.start).to eq(nil)
  end

  it 'runs the action' do
    action_double = double('NullAction', run: nil)

    ui = UserInterface.new(valid_input, output)
    controler = Controler.new(ui, [action_double])

    controler.start

    expect(action_double).to have_received(:run).once
  end
end
