# frozen_string_literal: true

require 'controler'
require 'user_interface'

RSpec.describe Controler do
  let(:actions) { [double('NullAction')] }
  let(:output) { StringIO.new }
  let(:valid_input) { StringIO.new('1') }

  it 'tells the user_interface to print the menu' do
    ui = UserInterface.new(valid_input, output)
    ctrl = Controler.new(ui, actions)

    allow(actions[0]).to receive(:run)

    ctrl.start

    expect(output.string).to include(MENU_MESSAGE)
  end

  it 'receives the input from the user_interface' do
    input = StringIO.new("2\n1\n")
    ui = UserInterface.new(input, output)
    ctrl = Controler.new(ui, actions)

    allow(actions[0]).to receive(:run)

    ctrl.start

    expect(output.string).to include(ERROR_MESSAGE)
  end

  it 'selects correct action to perform according to input' do
    ui = UserInterface.new(valid_input, output)
    ctrl = Controler.new(ui, actions)

    allow(actions[0]).to receive(:run)

    expect(ctrl.start).to eq(nil)
  end

  it 'runs the action' do
    ui = UserInterface.new(valid_input, output)
    ctrl = Controler.new(ui, actions)

    allow(actions[0]).to receive(:run)

    ctrl.start

    expect(actions[0]).to have_received(:run)
  end

  ERROR_MESSAGE = 'Wrong input. Please try again: '
  MENU_MESSAGE = %{
    ---------------------

        CONTACT BOOK

    ---------------------


  1) Exit the program

  Choose a menu option: }
end
