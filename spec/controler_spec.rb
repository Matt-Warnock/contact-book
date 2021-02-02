# frozen_string_literal: true

require 'controler'
require 'language_parser'
require 'null_action'
require 'user_interface'
require 'validator'

RSpec.describe Controler do
  let(:actions) { Array.new(messages.actions_count, NullAction.new) }
  let(:exit_choice) { messages.exit_choice }
  let(:messages) { LanguageParser.new('en.yml').messages }
  let(:output) { StringIO.new }

  it 'prints the menu before the action is run and after unless exit is chosen' do
    input = StringIO.new("1\n#{exit_choice}\n")
    ui = UserInterface.new(input, output, Validator.new, messages)
    controler = described_class.new(ui, actions, messages)

    controler.start

    expect(output.string.scan(messages.menu_message).length).to eq(2)
  end

  it 'receives the input from the user interface' do
    ui_double = double('UserInterface', menu_choice: exit_choice)
    controler = described_class.new(ui_double, actions, messages)

    controler.start

    expect(ui_double).to have_received(:menu_choice).once
  end

  it 'runs the actions chosen' do
    null_action = double('NullAction', run: nil)
    ui = UserInterface.new(StringIO.new("1\n#{exit_choice}\n"), output, Validator.new, messages)
    controler = described_class.new(ui, Array.new(messages.actions_count, null_action), messages)

    controler.start

    expect(null_action).to have_received(:run).twice
  end
end
