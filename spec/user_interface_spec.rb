# frozen_string_literal: true

require 'user_interface'

RSpec.describe UserInterface do
  let(:output) { StringIO.new }

  describe '#menu_choice' do
    let(:error_message) { described_class::ERROR_MESSAGE }
    let(:exit_choice) { described_class::CHOICE_TOTAL }
    let(:valid_input) { StringIO.new(exit_choice.to_s) }

    it 'prints menu of options for user to choose' do
      ui = described_class.new(valid_input, output)

      ui.menu_choice

      expect(output.string).to include(described_class::MENU_MESSAGE)
    end

    it 'clears the screen before printing the menu' do
      ui = described_class.new(valid_input, output)

      ui.menu_choice

      expect(output.string).to include("\033[H\033[2J" + described_class::MENU_MESSAGE)
    end

    it 'reads an input from the user' do
      ui = described_class.new(valid_input, output)

      user_input = ui.menu_choice

      expect(user_input).to eq(exit_choice)
    end

    it 'validates input, vaild numbers only' do
      input = StringIO.new("12\n#{exit_choice}\n")
      ui = described_class.new(input, output)

      ui.menu_choice

      expect(output.string).to include(error_message)
    end

    it 'reads the input again if input is invalid' do
      input = StringIO.new("yes\n2\n")
      ui = described_class.new(input, output)

      user_input = ui.menu_choice

      expect(user_input).to eq(exit_choice)
    end

    it 'repeats printing error message untill valid input is entered' do
      input = StringIO.new("yes\n0\n13\n2\n")
      ui = described_class.new(input, output)

      ui.menu_choice

      expect(output.string.scan(error_message).length).to eq(3)
    end

    it 'returns a valid input' do
      ui = described_class.new(valid_input, output)

      expect(ui.menu_choice).to eq(exit_choice)
    end
  end

  describe '#ask ask_for_fields' do
    let(:input) { StringIO.new(test_details.values.join("\n")) }
    let(:ui) { described_class.new(input, output) }

    it 'asks user for all fields' do
      ui.ask_for_fields

      expect(output.string).to include(described_class::FIELDS_TO_PROMPTS.values.join("\n"))
    end

    it 'gets the contact details' do
      contact_details = ui.ask_for_fields

      expect(contact_details).to eq(test_details)
    end

    it 'prints error if phone is invalid' do
      input = StringIO.new(invalid_inputs.values.join("\n"))
      ui = described_class.new(input, output)

      ui.ask_for_fields

      expect(output.string).to include(described_class::ERROR_MESSAGE)
    end

    it 'prints error if email is invalid' do
      input = StringIO.new(invalid_inputs.values.join("\n"))
      ui = described_class.new(input, output)

      ui.ask_for_fields

      expect(output.string).to include(described_class::ERROR_MESSAGE)
    end
  end

  describe '#display_contact' do
    it 'prints all fields of a contact hash' do
      input = StringIO.new
      ui = described_class.new(input, output)

      ui.display_contact(test_details)

      expect(output.string).to eq(
        %(Name:    Matt Damon
Address: Some address
Phone:   08796564231
Email:   matt@damon.com
Notes:   I think he has an Oscar
)
      )
    end
  end

  describe '#add_another_contact?' do
    it 'prints prompt to user' do
      input = StringIO.new('y')
      ui = described_class.new(input, output)

      ui.add_another_contact?

      expect(output.string).to include(described_class::ANOTHER_CONTACT_PROMPT)
    end

    it 'returns true if user wants to add another contact' do
      input = StringIO.new('y')
      ui = described_class.new(input, output)

      result = ui.add_another_contact?

      expect(result).to eq(true)
    end

    it 'returns false if user doesnt want to add another contact' do
      input = StringIO.new('n')
      ui = described_class.new(input, output)

      result = ui.add_another_contact?

      expect(result).to eq(false)
    end

    it 'prints error message if incorrect input is given' do
      input = StringIO.new("wrong input\ny\n")
      ui = described_class.new(input, output)

      ui.add_another_contact?

      expect(output.string).to include(described_class::ERROR_MESSAGE)
    end

    it 'ignores case sensitivity on valid inputs' do
      input = StringIO.new('Y')
      ui = described_class.new(input, output)

      ui.add_another_contact?

      expect(output.string).to_not include(described_class::ERROR_MESSAGE)
    end
  end

  def test_details
    {
      name: 'Matt Damon',
      address: 'Some address',
      phone: '08796564231',
      email: 'matt@damon.com',
      notes: 'I think he has an Oscar'
    }
  end

  def invalid_inputs
    {
      name: 'Matt Damon',
      address: 'Some address',
      invalid_phone: '08796564',
      phone: '08796564231',
      invalid_email: 'mattdamon.com',
      email: 'matt@damon.com',
      notes: 'I think he has an Oscar'
    }
  end
end
