# frozen_string_literal: true

require 'db/array_database'
require 'db/file_database'
require 'finder'
require 'language_parser'
require 'db/sqlite_database'
require 'user_interface'
require 'validator'

RSpec.shared_examples 'a Finder' do |database_class, argument|
  describe '#run' do
    let(:database) { argument ? database_class.new(argument) : database_class.new }
    let(:described_class) { Finder }
    let(:messages) { LanguageParser.new('locales/en.yml').messages }
    let(:output) { StringIO.new }
    let(:validator) { Validator.new }

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

    it 'askes user for a search_term' do
      input = StringIO.new("term\nn\n")
      user_interface = UserInterface.new(input, output, validator, messages)
      finder = described_class.new(user_interface, database)

      finder.run

      expect(output.string).to include(messages.search_message)
    end

    it 'prints message if no contacts are found' do
      input = StringIO.new("term\nn\n")
      user_interface = UserInterface.new(input, output, validator, messages)
      finder = described_class.new(user_interface, database)

      database.create(test_contact)

      finder.run

      expect(output.string).to include(messages.no_contacts_message)
    end

    it 'does not print a no contacts message if contacts are found' do
      input = StringIO.new("damon\nn\n")
      user_interface = UserInterface.new(input, output, validator, messages)
      finder = described_class.new(user_interface, database)

      database.create(test_contact)

      finder.run

      expect(output.string).not_to include(messages.no_contacts_message)
    end

    it 'prints the contacts that are found' do
      input = StringIO.new("damon\nn\n")
      user_interface = UserInterface.new(input, output, validator, messages)
      finder = described_class.new(user_interface, database)

      database.create(test_contact)

      finder.run

      expect(output.string).to include('Name:    Matt Damon')
    end

    it 'keeps asking user if they want to add another contact until they say no' do
      input = StringIO.new("term\ny\ndamon\ny\nterm\nn\n")
      user_interface = UserInterface.new(input, output, validator, messages)
      finder = described_class.new(user_interface, database)

      database.create(test_contact)

      finder.run

      expect(output.string.scan(messages.another_search_prompt).length).to eq(3)
    end
  end

  def test_contact
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
  it_behaves_like 'a Finder', [DB::ArrayDatabase, nil]
end

RSpec.describe 'with File Database' do
  it_behaves_like 'a Finder', [DB::FileDatabase, Tempfile.new('test')]
end

RSpec.describe 'with SQLite3 Database' do
  it_behaves_like 'a Finder', [DB::SQLiteDatabase, ':memory:']
end
