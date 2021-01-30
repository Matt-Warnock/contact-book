# frozen_string_literal: true

require 'array_database'
require 'constants'
require 'file_database'
require 'language_parser'
require 'updater'
require 'user_interface'
require 'validator'

RSpec.shared_examples 'an Updater' do |database_class, argument|
  let(:database) { argument ? database_class.new(argument) : database_class.new }
  let(:messages) { LanguageParser.new(Pathname.new('en.yml')).messages }
  let(:output) { StringIO.new }
  let(:quick_exit_responces) { "0\nname\nirrelevant\nn\nn\n" }

  after(:each) do
    if argument
      argument.truncate(0)
      argument.rewind
    end
  end

  after(:all) do
    if argument
      argument.close
      argument.unlink
    end
  end

  describe '#run' do
    it 'displays that no contacts are found if database is empty' do
      run_updater_with_empty_database

      expect(output.string).to include(messages.NO_CONTACTS_MESSAGE)
    end

    it 'does not ask updating prompt if database is empty' do
      run_updater_with_empty_database

      expect(output.string).to_not include(messages.CONTACT_INDEX_PROMPT)
    end

    it 'asks the user for a contact to update' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(messages.CONTACT_INDEX_PROMPT)
    end

    it 'prints contact to be edited' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string.scan(/Name:    Matt Damon/).length).to eq(2)
    end

    it 'asks the user which field it wants to update and the value for it' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(messages.FIELD_CHOICE_PROMPT, Constants::FIELDS_TO_PROMPTS[:name])
    end

    it 'displays the contact with the data updated' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include("Name:    irrelevant\nAddress: Some address")
    end

    it 'asks the user if they want to edit another field' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(messages.ANOTHER_EDIT_PROMPT)
    end

    it 'collects another field and value if they want to edit another field' do
      input = "0\nname\nirrelevant\ny\naddress\nirrelevant\nn\nn\n"
      run_updater_with_input(input)

      expect(output.string.scan(messages.FIELD_CHOICE_PROMPT).length).to eq(2)
    end

    it 'asks if they want to edit another contact if they do not want to edit another field' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(messages.ANOTHER_UPDATE_PROMPT)
    end

    it 'asks for another contact index if they want to edit another contact' do
      input = "0\nname\nirrelevant\ny\naddress\nirrelevant\nn\ny\n" + quick_exit_responces
      run_updater_with_input(input)

      expect(output.string.scan(messages.CONTACT_INDEX_PROMPT).length).to eq(2)
    end
  end

  def run_updater_with_input(string)
    user_interface = UserInterface.new(StringIO.new(string), output, Validator.new(messages), messages)

    database.create(test_details)

    Updater.new(user_interface, database).run
  end

  def run_updater_with_empty_database
    user_interface = UserInterface.new(StringIO.new("\n"), output, Validator.new(messages), messages)

    Updater.new(user_interface, database).run
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

RSpec.describe 'with Array Database' do
  it_behaves_like 'an Updater', [ArrayDatabase, nil]
end

RSpec.describe 'with File Database' do
  it_behaves_like 'an Updater', [FileDatabase, Tempfile.new('test')]
end
