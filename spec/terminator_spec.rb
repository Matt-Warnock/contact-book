# frozen_string_literal: true

require 'array_database'
require 'terminator'
require 'user_interface'
require 'validator'

RSpec.describe Terminator do
  describe '#run' do
    let(:array_database) { ArrayDatabase.new }
    let(:output) { StringIO.new }
    let(:delete_contact_path) { "0\ny\nn\n" }

    it 'prints there is no contacts if the database is empty' do
      run_terminator_without_contacts

      expect(output.string).to include(Constants::NO_CONTACTS_MESSAGE)
    end

    it 'exits if the database is empty' do
      run_terminator_without_contacts

      expect(output.string).to_not include(Constants::CONTACT_INDEX_PROMPT)
    end

    it 'asks user to choose a contact' do
      run_terminator_with_input(delete_contact_path)

      expect(output.string).to include(Constants::CONTACT_INDEX_PROMPT)
    end

    it 'prints the contact the user has chosen to delete' do
      run_terminator_with_input(delete_contact_path)

      expect(output.string.scan('Matt Damon').length).to eq(2)
    end

    it 'asks the user for confirmation to delete' do
      run_terminator_with_input(delete_contact_path)

      expect(output.string).to include(Constants::DELETE_CONTACT_PROMPT)
    end

    it 'does not delete contact if user chooses not to delete' do
      run_terminator_with_input("0\nn\nn\n")

      expect(array_database.all).to include(test_details)
    end

    it 'deletes contact if user chooses to delete' do
      run_terminator_with_input(delete_contact_path)

      expect(array_database.all).to_not include(test_details)
    end

    it 'prints confirmation that contact was deleted if user chooses to delete' do
      run_terminator_with_input(delete_contact_path)

      expect(output.string).to include(Constants::CONTACT_DELETED_MESSAGE)
    end

    it 'asks the user if they would like to delete another contact' do
      run_terminator_with_input(delete_contact_path)

      expect(output.string).to include(Constants::ANOTHER_DELETE_PROMPT)
    end

    it 'asks the user for another contact index if they want to delete another contact' do
      run_terminator_with_input("0\ny\ny\n0\ny\nn\n")

      expect(output.string.scan(Constants::CONTACT_INDEX_PROMPT).length).to eq(2)
    end

    it 'exits if they no not want to delete another contact' do
      run_terminator_with_input(delete_contact_path)

      expect(output.string.scan(Constants::CONTACT_INDEX_PROMPT).length).to eq(1)
    end
  end

  def run_terminator_with_input(input)
    user_interface = UserInterface.new(StringIO.new(input), output, Validator.new)

    array_database.create(test_details)
    array_database.create(second_contact)

    Terminator.new(user_interface, array_database).run
  end

  def run_terminator_without_contacts
    user_interface = UserInterface.new(StringIO.new, output, Validator.new)

    Terminator.new(user_interface, array_database).run
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

  def second_contact
    {
      name: 'oscar wilde',
      address: 'Paris',
      phone: '00000000000',
      email: 'oscar@wilde.com',
      notes: 'I think he has an oscar'
    }
  end
end
