# frozen_string_literal: true

require 'controler'
require 'user_interface'
require 'null_action'

RSpec.describe Controler do
  let(:valid_input) { StringIO.new('1') }
  let(:output) { StringIO.new }
  let(:actions) { [NullAction.new] }

  it 'tells the user_interface to print the menu' do
    ui = UserInterface.new(valid_input, output)
    ctrl = Controler.new(ui, actions)

    ctrl.start

    expect(output.string).to include('CONTACT BOOK')
  end

  it 'receives the input from the user_interface' do
    input = StringIO.new("2\n1\n")
    ui = UserInterface.new(input, output)
    ctrl = Controler.new(ui, actions)

    ctrl.start

    expect(output.string).to include('Wrong input. Please try again: ')
  end

  it 'selects correct action to perform according to input' do
    ui = UserInterface.new(valid_input, output)
    ctrl = Controler.new(ui, actions)

    ctrl.start

    expect(actions[0]).to be_called
  end
end
