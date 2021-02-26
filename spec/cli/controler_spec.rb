# frozen_string_literal: true

require 'cli/controler'
require 'language_parser'
require 'actions/null_action'
require 'cli/user_interface'
require 'cli/validator'

RSpec.describe CLI::Controler do
  let(:actions) { Array.new(messages.actions_count, Actions::NullAction.new) }
  let(:exit_choice) { messages.exit_choice }
  let(:messages) { LanguageParser.new('locales/en.yml').messages }
  let(:output) { StringIO.new }

  it 'prints the menu before the action is run and after unless exit is chosen' do
    input = StringIO.new("1\n#{exit_choice}\n")
    ui = CLI::UserInterface.new(input, output, CLI::Validator.new, messages)
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
    ui = CLI::UserInterface.new(StringIO.new("1\n#{exit_choice}\n"), output, CLI::Validator.new, messages)
    controler = described_class.new(ui, Array.new(messages.actions_count, null_action), messages)

    controler.start

    expect(null_action).to have_received(:run).twice
  end
end
