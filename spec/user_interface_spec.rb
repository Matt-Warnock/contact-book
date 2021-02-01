# frozen_string_literal: true

require 'language_parser'
require 'user_interface'
require 'validator'

RSpec.describe UserInterface do
  let(:output) { StringIO.new }
  let(:messages) { LanguageParser.new(Pathname.new('en.yml')).messages }
  let(:validator) { Validator.new(messages) }
  let(:yes_reply) { messages.yes_reply + "\n" }

  describe '#menu_choice' do
    let(:valid_input) { StringIO.new("1\n") }

    it 'prints menu of options for user to choose' do
      ui = described_class.new(valid_input, output, validator, messages)

      ui.menu_choice

      expect(output.string).to include(messages.menu_message)
    end

    it 'clears the screen before printing the menu' do
      ui = described_class.new(valid_input, output, validator, messages)

      ui.menu_choice

      expect(output.string).to include("\033[H\033[2J" + messages.menu_message)
    end

    it 'reads an input from the user' do
      ui = described_class.new(valid_input, output, validator, messages)

      user_input = ui.menu_choice

      expect(user_input).to eq(1)
    end

    it 'reads the input again if input is invalid' do
      input = StringIO.new("yes\n1\n")
      ui = described_class.new(input, output, validator, messages)

      user_input = ui.menu_choice

      expect(user_input).to eq(1)
    end

    it 'repeats printing error message untill valid input is entered' do
      input = StringIO.new("yes\n0\n#{messages.actions_count + 1}\n1\n")
      ui = described_class.new(input, output, validator, messages)

      ui.menu_choice

      expect(output.string.scan(messages.error_message).length).to eq(3)
    end

    it 'returns a valid input' do
      ui = described_class.new(valid_input, output, validator, messages)

      expect(ui.menu_choice).to eq(1)
    end
  end

  describe '#ask_for_fields' do
    let(:input) { StringIO.new(test_details.values.join("\n")) }
    let(:ui) { described_class.new(input, output, validator, messages) }

    it 'asks user for all fields' do
      ui.ask_for_fields

      expect(output.string).to include(messages.fields_to_prompts.to_h.values.join)
    end

    it 'gets the contact details' do
      contact_details = ui.ask_for_fields

      expect(contact_details).to eq(test_details)
    end

    it 'prints error if phone is invalid' do
      input = StringIO.new(invalid_inputs.values.join("\n"))
      ui = described_class.new(input, output, validator, messages)

      ui.ask_for_fields

      expect(output.string).to include(messages.error_message)
    end

    it 'prints error if email is invalid' do
      input = StringIO.new(invalid_inputs.values.join("\n"))
      ui = described_class.new(input, output, validator, messages)

      ui.ask_for_fields

      expect(output.string).to include(messages.error_message)
    end
  end

  describe '#display_contact' do
    it 'prints an empty line then all fields of a contact hash' do
      input = StringIO.new
      ui = described_class.new(input, output, validator, messages)

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
      ui = described_class.new(input, output, validator, messages)

      ui.add_another_contact?

      expect(output.string).to include(messages.another_contact_prompt)
    end

    it 'returns true if user wants to add another contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      result = ui.add_another_contact?

      expect(result).to eq(true)
    end

    it 'returns false if user doesnt want to add another contact' do
      input = StringIO.new("n\n")
      ui = described_class.new(input, output, validator, messages)

      result = ui.add_another_contact?

      expect(result).to eq(false)
    end

    it 'prints error message if incorrect input is given' do
      input = StringIO.new("wrong input\n#{yes_reply}")
      ui = described_class.new(input, output, validator, messages)

      ui.add_another_contact?

      expect(output.string).to include(messages.error_message)
    end
  end

  describe '#display_no_contacts_message' do
    it 'prints a message expressing there are no contacts to display' do
      input = StringIO.new
      ui = described_class.new(input, output, validator, messages)

      ui.display_no_contacts_message

      expect(output.string).to include(messages.no_contacts_message)
    end
  end

  describe '#display_letter_header' do
    it 'prints the header styling with a given letter' do
      input = StringIO.new
      ui = described_class.new(input, output, validator, messages)

      ui.display_letter_header('A')

      expect(output.string).to eq(%(
------------------------------
              A
------------------------------
))
    end

    it 'takes a letter with any casing' do
      input = StringIO.new
      ui = described_class.new(input, output, validator, messages)

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
      ui = described_class.new(input, output, validator, messages)

      ui.continue

      expect(output.string).to eq(messages.continue_message)
    end

    it 'returns single character entered by user' do
      input = StringIO.new('x')
      ui = described_class.new(input, output, validator, messages)

      expect(ui.continue).to eq('x')
    end
  end

  describe '#search_term' do
    it 'prints a prompt asking user for a search term' do
      input = StringIO.new("john\n")
      ui = described_class.new(input, output, validator, messages)

      ui.search_term

      expect(output.string).to include(messages.search_message)
    end

    it 'returns the search term typed by user' do
      input = StringIO.new("john\n")
      ui = described_class.new(input, output, validator, messages)

      expect(ui.search_term).to eq('john')
    end

    it 'prints error message and reads input until vaiid input is given' do
      input = StringIO.new("\njohn\n")
      ui = described_class.new(input, output, validator, messages)

      ui.search_term

      expect(output.string).to include(messages.error_message)
    end
  end

  describe '#search_again?' do
    it 'prints a prompt to user asking to search for another contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      ui.search_again?

      expect(output.string).to include(messages.another_search_prompt)
    end

    it 'returns true if user wants to search another contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      expect(ui.search_again?).to eq(true)
    end

    it 'returns false if user doesnt want to search another contact' do
      input = StringIO.new("n\n")
      ui = described_class.new(input, output, validator, messages)

      expect(ui.search_again?).to eq(false)
    end

    it 'prints error message and reads input until correct input is given' do
      input = StringIO.new("wrong input\n#{yes_reply}")
      ui = described_class.new(input, output, validator, messages)

      ui.search_again?

      expect(output.string).to include(messages.error_message)
    end
  end

  describe '#choose_contact' do
    let(:input) { StringIO.new("0\n") }

    it 'prints all the contacts with an index' do
      ui = described_class.new(input, output, validator, messages)

      contact_a = { name: 'Matt Damon' }
      contact_b = { name: 'John Doe' }

      ui.choose_contact([contact_a, contact_b])

      expect(output.string).to match(/\[0\]\nName:    Matt Damon\n\[1\]\nName:    John Doe/)
    end

    it 'prints a prompt to user to choose an index' do
      ui = described_class.new(input, output, validator, messages)

      ui.choose_contact([test_details])

      expect(output.string).to include(messages.contact_index_prompt)
    end

    it 'returns a vaild index choice' do
      ui = described_class.new(input, output, validator, messages)

      result = ui.choose_contact([test_details])

      expect(result).to eq(0)
    end

    it 'only takes vaild index choice' do
      invalid_input = StringIO.new("1\n0\n")
      ui = described_class.new(invalid_input, output, validator, messages)

      ui.choose_contact([test_details])

      expect(output.string).to include(messages.error_message)
    end
  end

  describe '#edit_field' do
    it 'prints prompt for user to enter field name to be edited' do
      input = StringIO.new("name\nJoe\n")
      ui = described_class.new(input, output, validator, messages)

      ui.edit_field

      expect(output.string).to include(messages.field_choice_prompt)
    end

    it 'only takes a vaild field name' do
      input = StringIO.new("surname\nemail\njoe@hotmail.com\n")
      ui = described_class.new(input, output, validator, messages)

      ui.edit_field

      expect(output.string).to include(messages.error_message)
    end

    it 'asks the user for the new value for field given' do
      input = StringIO.new("email\njoe@hotmail.com\n")
      ui = described_class.new(input, output, validator, messages)

      ui.edit_field

      expect(output.string).to include(messages.fields_to_prompts[:email])
    end

    it 'only takes a vaild value for field given' do
      input = StringIO.new("email\njoe.hotmail.com\njoe@hotmail.com\n")
      ui = described_class.new(input, output, validator, messages)

      ui.edit_field

      expect(output.string).to include(messages.error_message)
    end

    it 'returns a hash with new value entered' do
      input = StringIO.new("email\njoe@hotmail.com\n")
      ui = described_class.new(input, output, validator, messages)

      result = ui.edit_field

      expect(result).to eq({ email: 'joe@hotmail.com' })
    end
  end

  describe '#update_another_field?' do
    it 'prints a prompt to user asking if they want to change another field' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      ui.update_another_field?

      expect(output.string).to include(messages.another_edit_prompt)
    end

    it 'returns true if user wants to add another field' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      expect(ui.update_another_field?).to eq(true)
    end

    it 'returns false if user doesnt want to add another field' do
      input = StringIO.new("n\n")
      ui = described_class.new(input, output, validator, messages)

      expect(ui.update_another_field?).to eq(false)
    end

    it 'prints error message and reads input until correct input is given' do
      input = StringIO.new("wrong input\n#{yes_reply}")
      ui = described_class.new(input, output, validator, messages)

      ui.update_another_field?

      expect(output.string).to include(messages.error_message)
    end
  end

  describe '#update_another_contact?' do
    it 'prints a prompt to user asking if they want to change another field' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      ui.update_another_contact?

      expect(output.string).to include(messages.another_update_prompt)
    end

    it 'returns true if user wants to add another field' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      expect(ui.update_another_contact?).to eq(true)
    end

    it 'returns false if user doesnt want to add another field' do
      input = StringIO.new("n\n")
      ui = described_class.new(input, output, validator, messages)

      expect(ui.update_another_contact?).to eq(false)
    end

    it 'prints error message and reads input until correct input is given' do
      input = StringIO.new("wrong input\n#{yes_reply}")
      ui = described_class.new(input, output, validator, messages)

      ui.update_another_contact?

      expect(output.string).to include(messages.error_message)
    end
  end

  describe '#delete?' do
    it 'prints a prompt to user asking if they want to delete the contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      ui.delete?(test_details)

      expect(output.string).to include(messages.delete_contact_prompt)
    end

    it 'prints the contact after delete prompt' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      ui.delete?(test_details)

      expect(output.string).to include(messages.delete_contact_prompt + "\nName:    Matt Damon")
    end

    it 'returns true if user wants to delete the contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      expect(ui.delete?(test_details)).to eq(true)
    end

    it 'returns false if user doesnt want to delete the contact' do
      input = StringIO.new("n\n")
      ui = described_class.new(input, output, validator, messages)

      expect(ui.delete?(test_details)).to eq(false)
    end

    it 'prints error message and reads input until correct input is given' do
      input = StringIO.new("wrong input\n#{yes_reply}")
      ui = described_class.new(input, output, validator, messages)

      ui.delete?(test_details)

      expect(output.string).to include(messages.error_message)
    end
  end

  describe '#display_deletion_message' do
    it 'prints that the contact was deleted' do
      input = StringIO.new
      ui = described_class.new(input, output, validator, messages)

      ui.display_deletion_message

      expect(output.string).to include(messages.contact_deleted_message)
    end
  end

  describe '#delete_another_contact?' do
    it 'prints a prompt to user asking if they want to delete another contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      ui.delete_another_contact?

      expect(output.string).to include(messages.another_delete_prompt)
    end

    it 'returns true if user wants to delete another contact' do
      input = StringIO.new(yes_reply)
      ui = described_class.new(input, output, validator, messages)

      expect(ui.delete_another_contact?).to eq(true)
    end

    it 'returns false if user doesnt want to delete another contact' do
      input = StringIO.new("n\n")
      ui = described_class.new(input, output, validator, messages)

      expect(ui.delete_another_contact?).to eq(false)
    end

    it 'prints error message and reads input until correct input is given' do
      input = StringIO.new("wrong input\n#{yes_reply}")
      ui = described_class.new(input, output, validator, messages)

      ui.delete_another_contact?

      expect(output.string).to include(messages.error_message)
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
