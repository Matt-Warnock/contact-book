# frozen_string_literal: true

require 'array_database'
require 'constants'
require 'updater'
require 'user_interface'
require 'validator'

RSpec.describe Updater do
  let(:output) { StringIO.new }
  let(:quick_exit_responces) { "0\nname\nirrelevant\nn\nn\n" }

  describe '#run' do
    it 'displays that no contacts are found if database is empty' do
      run_updater_with_empty_database

      expect(output.string).to include(Constants::NO_CONTACTS_MESSAGE)
    end

    it 'does not ask updating prompt if database is empty' do
      run_updater_with_empty_database

      expect(output.string).to_not include(Constants::CONTACT_INDEX_PROMPT)
    end

    it 'asks the user for a contact to update' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(Constants::CONTACT_INDEX_PROMPT)
    end

    it 'asks the user which field it wants to update and the value for it' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(Constants::FIELD_CHOICE_PROMPT, Constants::FIELDS_TO_PROMPTS[:name])
    end

    it 'displays the contact with the data updated' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include("Name:    irrelevant\nAddress: Some address")
    end

    it 'asks the user if they want to edit another field' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(Constants::ANOTHER_EDIT_PROMPT)
    end

    it 'collects another field and value if they want to edit another field' do
      input = "0\nname\nirrelevant\ny\naddress\nirrelevant\nn\nn\n"
      run_updater_with_input(input)

      expect(output.string.scan(Constants::FIELD_CHOICE_PROMPT).length).to eq(2)
    end

    it 'asks if they want to edit another contact if they do not want to edit another field' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(Constants::ANOTHER_UPDATE_PROMPT)
    end

    it 'asks for another contact index if they want to edit another contact' do
      input = "0\nname\nirrelevant\ny\naddress\nirrelevant\nn\ny\n" + quick_exit_responces
      run_updater_with_input(input)

      expect(output.string.scan(Constants::CONTACT_INDEX_PROMPT).length).to eq(2)
    end
  end

  def run_updater_with_input(string)
    user_interface = UserInterface.new(StringIO.new(string), output, Validator.new)

    database = ArrayDatabase.new
    database.create(test_details)

    described_class.new(user_interface, database).run
  end

  def run_updater_with_empty_database
    user_interface = UserInterface.new(StringIO.new("\n"), output, Validator.new)
    database = ArrayDatabase.new

    described_class.new(user_interface, database).run
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
end
