# frozen_string_literal: true

require 'db/array_database'
require 'file_database'
require 'language_parser'
require 'sqlite_database'
require 'updater'
require 'user_interface'
require 'validator'

RSpec.shared_examples 'an Updater' do |database_class, argument|
  let(:database) { argument ? database_class.new(argument) : database_class.new }
  let(:messages) { LanguageParser.new('locales/en.yml').messages }
  let(:output) { StringIO.new }
  let(:quick_exit_responces) { "0\nname\nirrelevant\nn\nn\n" }

  after(:each) do
    if argument.instance_of?(Tempfile)
      argument.truncate(0)
      argument.rewind
    end
  end

  after(:all) do
    if argument.instance_of?(Tempfile)
      argument.close
      argument.unlink
    end
  end

  describe '#run' do
    it 'displays that no contacts are found if database is empty' do
      run_updater_with_empty_database

      expect(output.string).to include(messages.no_contacts_message)
    end

    it 'does not ask updating prompt if database is empty' do
      run_updater_with_empty_database

      expect(output.string).to_not include(messages.contact_index_prompt)
    end

    it 'asks the user for a contact to update' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(messages.contact_index_prompt)
    end

    it 'prints contact to be edited' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string.scan(/Name:    Matt Damon/).length).to eq(2)
    end

    it 'asks the user which field it wants to update and the value for it' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(messages.field_choice_prompt, messages.fields_to_prompts[:name])
    end

    it 'displays the contact with the data updated' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include("Name:    irrelevant\nAddress: Some address")
    end

    it 'asks the user if they want to edit another field' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(messages.another_edit_prompt)
    end

    it 'collects another field and value if they want to edit another field' do
      input = "0\nname\nirrelevant\ny\naddress\nirrelevant\nn\nn\n"
      run_updater_with_input(input)

      expect(output.string.scan(messages.field_choice_prompt).length).to eq(2)
    end

    it 'asks if they want to edit another contact if they do not want to edit another field' do
      run_updater_with_input(quick_exit_responces)

      expect(output.string).to include(messages.another_update_prompt)
    end

    it 'asks for another contact index if they want to edit another contact' do
      input = "0\nname\nirrelevant\ny\naddress\nirrelevant\nn\ny\n" + quick_exit_responces
      run_updater_with_input(input)

      expect(output.string.scan(messages.contact_index_prompt).length).to eq(2)
    end
  end

  def run_updater_with_input(string)
    user_interface = UserInterface.new(StringIO.new(string), output, Validator.new, messages)

    database.create(test_details)

    Updater.new(user_interface, database).run
  end

  def run_updater_with_empty_database
    user_interface = UserInterface.new(StringIO.new("\n"), output, Validator.new, messages)

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
  it_behaves_like 'an Updater', [DB::ArrayDatabase, nil]
end

RSpec.describe 'with File Database' do
  it_behaves_like 'an Updater', [FileDatabase, Tempfile.new('test')]
end

RSpec.describe 'with SQLite3 Database' do
  it_behaves_like 'an Updater', [SQLiteDatabase, ':memory:']
end
