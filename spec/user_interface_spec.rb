# frozen_string_literal: true

require 'user_interface'
require 'validator'

RSpec.describe UserInterface do
  let(:output) { StringIO.new }
  let(:validator) { Validator.new }
  let(:yes_reply) { UserInterface::YES_REPLY + "\n" }

  describe '#menu_choice' do
    let(:error_message) { described_class::ERROR_MESSAGE }
    let(:exit_choice) { described_class::EXIT_CHOICE }
    let(:valid_input) { StringIO.new(exit_choice.to_s + "\n") }

    it 'prints menu of options for user to choose' do
      ui = described_class.new(valid_input, output, validator)

      ui.menu_choice

      expect(output.string).to include(described_class::MENU_MESSAGE)
    end

    it 'clears the screen before printing the menu' do
      ui = described_class.new(valid_input, output, validator)

      ui.menu_choice

      expect(output.string).to include("\033[H\033[2J" + described_class::MENU_MESSAGE)
    end

    it 'reads an input from the user' do
      ui = described_class.new(valid_input, output, validator)

      user_input = ui.menu_choice

      expect(user_input).to eq(exit_choice)
    end

    it 'reads the input again if input is invalid' do
      input = StringIO.new("yes\n#{exit_choice}\n")
      ui = described_class.new(input, output, validator)

      user_input = ui.menu_choice

      expect(user_input).to eq(exit_choice)
    end

    it 'repeats printing error message untill valid input is entered' do
      input = StringIO.new("yes\n0\n13\n#{exit_choice}\n")
      ui = described_class.new(input, output, validator)

      ui.menu_choice

      expect(output.string.scan(error_message).length).to eq(3)
    end

    it 'returns a valid input' do
      ui = described_class.new(valid_input, output, validator)

      expect(ui.menu_choice).to eq(exit_choice)
    end
  end

  describe '#ask_for_fields' do
    let(:input) { StringIO.new(test_details.values.join("\n")) }
    let(:ui) { described_class.new(input, output, validator) }

    it 'asks user for all fields' do
      ui.ask_for_fields

      expect(output.string).to include(described_class::FIELDS_TO_PROMPTS.values.join)
    end

    it 'gets the contact details' do
      contact_details = ui.ask_for_fields

      expect(contact_details).to eq(test_details)
    end

    it 'prints error if phone is invalid' do
      input = StringIO.new(invalid_inputs.values.join("\n"))
      ui = described_class.new(input, output, validator)

      ui.ask_for_fields

      expect(output.string).to include(described_class::ERROR_MESSAGE)
    end

    it 'prints error if email is invalid' do
      input = StringIO.new(invalid_inputs.values.join("\n"))
      ui = described_class.new(input, output, validator)

      ui.ask_for_fields

      expect(output.string).to include(described_class::ERROR_MESSAGE)
    end
  end

  describe '#display_contact' do
    it 'prints an empty line then all fields of a contact hash' do
      input = StringIO.new
      ui = described_class.new(input, output, validator)

      ui.display_contact(test_details)

      expect(output.string).to eq(
        %(
Name:    Matt Damon
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
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator)

      ui.add_another_contact?

      expect(output.string).to include(described_class::ANOTHER_CONTACT_PROMPT)
    end

    it 'returns true if user wants to add another contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator)

      result = ui.add_another_contact?

      expect(result).to eq(true)
    end

    it 'returns false if user doesnt want to add another contact' do
      input = StringIO.new("n\n")
      ui = described_class.new(input, output, validator)

      result = ui.add_another_contact?

      expect(result).to eq(false)
    end

    it 'prints error message if incorrect input is given' do
      input = StringIO.new("wrong input\n#{yes_reply}")
      ui = described_class.new(input, output, validator)

      ui.add_another_contact?

      expect(output.string).to include(described_class::ERROR_MESSAGE)
    end

    it 'ignores case sensitivity for vaild input' do
      input = StringIO.new(yes_reply.upcase)
      ui = described_class.new(input, output, validator)

      result = ui.add_another_contact?

      expect(result).to eq(true)
    end
  end

  describe '#display_no_contacts_message' do
    it 'prints a message expressing there are no contacts to display' do
      input = StringIO.new
      ui = described_class.new(input, output, validator)

      ui.display_no_contacts_message

      expect(output.string).to include(described_class::NO_CONTACTS_MESSAGE)
    end
  end

  describe '#display_letter_header' do
    it 'prints the header styling with a given letter' do
      input = StringIO.new
      ui = described_class.new(input, output, validator)

      ui.display_letter_header('A')

      expect(output.string).to eq(%(
------------------------------
              A
------------------------------
))
    end

    it 'takes a letter with any casing' do
      input = StringIO.new
      ui = described_class.new(input, output, validator)

      ui.display_letter_header('a')

      expect(output.string).to eq(%(
------------------------------
              A
------------------------------
))
    end
  end

  describe '#continue' do
    it 'prints prompt to press any to continue' do
      input = StringIO.new('x')
      ui = described_class.new(input, output, validator)

      ui.continue

      expect(output.string).to eq(described_class::CONTINUE_MESSAGE)
    end

    it 'returns single character entered by user' do
      input = StringIO.new('x')
      ui = described_class.new(input, output, validator)

      expect(ui.continue).to eq('x')
    end
  end

  describe '#search_term' do
    it 'prints a prompt asking user for a search term' do
      input = StringIO.new("john\n")
      ui = described_class.new(input, output, validator)

      ui.search_term

      expect(output.string).to include(described_class::SEARCH_MESSAGE)
    end

    it 'returns the search term typed by user' do
      input = StringIO.new("john\n")
      ui = described_class.new(input, output, validator)

      expect(ui.search_term).to eq('john')
    end

    it 'prints error message and reads input until vaiid input is given' do
      input = StringIO.new("\njohn\n")
      ui = described_class.new(input, output, validator)

      ui.search_term

      expect(output.string).to include(described_class::ERROR_MESSAGE)
    end
  end

  describe '#search_again?' do
    it 'prints a prompt to user asking to search for another contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator)

      ui.search_again?

      expect(output.string).to include(described_class::ANOTHER_SEARCH_PROMPT)
    end

    it 'returns true if user wants to search another contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator)

      expect(ui.search_again?).to eq(true)
    end

    it 'returns false if user doesnt want to search another contact' do
      input = StringIO.new("n\n")
      ui = described_class.new(input, output, validator)

      expect(ui.search_again?).to eq(false)
    end

    it 'prints error message and reads input until correct input is given' do
      input = StringIO.new("wrong input\n#{yes_reply}")
      ui = described_class.new(input, output, validator)

      ui.search_again?

      expect(output.string).to include(described_class::ERROR_MESSAGE)
    end

    it 'ignores case sensitivity for vaild input' do
      input = StringIO.new(yes_reply.upcase)
      ui = described_class.new(input, output, validator)

      result = ui.search_again?

      expect(result).to eq(true)
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
