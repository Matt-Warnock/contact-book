# frozen_string_literal: true

require 'array_database'
require 'file_database'
require 'language_parser'
require 'terminator'
require 'sqlite_database'
require 'user_interface'
require 'validator'

RSpec.shared_examples 'a Terminator' do |database_class, argument|
  describe '#run' do
    let(:database) { argument ? database_class.new(argument) : database_class.new }
    let(:messages) { LanguageParser.new('locales/en.yml').messages }
    let(:output) { StringIO.new }
    let(:delete_one_contact_input) { "0\ny\nn\n" }
    let(:delete_both_contacts_input) { "0\ny\ny\n0\ny\n" }

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

    it 'prints there is no contacts if the database is empty' do
      run_terminator_without_contacts

      expect(output.string).to include(messages.no_contacts_message)
    end

    it 'asks the user to press any key to continue' do
      run_terminator_without_contacts

      expect(output.string).to include(messages.continue_message)
    end

    it 'exits if the database is empty' do
      run_terminator_without_contacts

      expect(output.string).to_not include(messages.contact_index_prompt)
    end

    it 'asks user to choose a contact' do
      run_terminator_with_input(delete_one_contact_input)

      expect(output.string).to include(messages.contact_index_prompt)
    end

    it 'prints the contact the user has chosen to delete' do
      run_terminator_with_input(delete_one_contact_input)

      expect(output.string.scan('Matt Damon').length).to eq(2)
    end

    it 'asks the user for confirmation to delete' do
      run_terminator_with_input(delete_one_contact_input)

      expect(output.string).to include(messages.delete_contact_prompt)
    end

    it 'does not delete contact if user chooses not to delete' do
      run_terminator_with_input("0\nn\nn\n")

      expect(database.all.first).to include(test_details)
    end

    it 'deletes contact if user chooses to delete' do
      run_terminator_with_input(delete_one_contact_input)

      expect(database.all.first).to_not include(test_details)
    end

    it 'prints confirmation that contact was deleted if user chooses to delete' do
      run_terminator_with_input(delete_one_contact_input)

      expect(output.string).to include(messages.contact_deleted_message)
    end

    it 'asks the user if they would like to delete another contact' do
      run_terminator_with_input(delete_one_contact_input)

      expect(output.string).to include(messages.another_delete_prompt)
    end

    it 'displays no contacts message if user wants to delete another contact and the database is empty' do
      run_terminator_with_input(delete_both_contacts_input + "y\n")

      expect(output.string).to include(messages.no_contacts_message)
    end

    it 'asks the user for another contact index if they want to delete another contact' do
      run_terminator_with_input(delete_both_contacts_input + "n\n")

      expect(output.string.scan(messages.contact_index_prompt).length).to eq(2)
    end

    it 'exits if they no not want to delete another contact' do
      run_terminator_with_input(delete_one_contact_input)

      expect(output.string.scan(messages.contact_index_prompt).length).to eq(1)
    end
  end

  def run_terminator_with_input(input)
    user_interface = UserInterface.new(StringIO.new(input), output, Validator.new, messages)

    database.create(test_details)
    database.create(second_contact)

    Terminator.new(user_interface, database).run
  end

  def run_terminator_without_contacts
    user_interface = UserInterface.new(StringIO.new, output, Validator.new, messages)

    Terminator.new(user_interface, database).run
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

RSpec.describe 'with Array Database' do
  it_behaves_like 'a Terminator', [ArrayDatabase, nil]
end

RSpec.describe 'with File Database' do
  it_behaves_like 'a Terminator', [FileDatabase, Tempfile.new('test')]
end

RSpec.describe 'with SQLite3 Database' do
  it_behaves_like 'a Terminator', [SQLiteDatabase, ':memory:']
end
