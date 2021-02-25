# frozen_string_literal: true

require 'db/array_database'
require 'db/file_database'
require 'language_parser'
require 'pager'
require 'db/sqlite_database'
require 'user_interface'
require 'validator'

RSpec.shared_examples 'a Pager' do |database_class, argument|
  let(:database) { argument ? database_class.new(argument) : database_class.new }
  let(:input) { StringIO.new }
  let(:messages) { LanguageParser.new('locales/en.yml').messages }
  let(:output) { StringIO.new }
  let(:pager) { Pager.new(user_interface, database) }
  let(:user_interface) { UserInterface.new(input, output, validator, messages) }
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

  describe '#run' do
    it 'prints a message to the user if the database is empty' do
      pager.run

      expect(output.string).to include(messages.no_contacts_message)
    end

    it 'does not prints a message if the database has any contacts' do
      database.create({ name: 'Matt Damon' })

      pager.run

      expect(output.string).to_not include(messages.no_contacts_message)
    end

    it 'sorts contacts into aphabetical order according to name' do
      database.create({ name: 'Warran Smith' })
      database.create({ name: 'Matt Damon' })

      pager.run

      expect(output.string).to match(/(Matt Damon)[\s\w:-]+(Warran Smith)/)
    end

    it 'aphabeticaly sorts same name contacts by email' do
      database.create({ name: 'Warran Smith', email: 'warran@yahoo.com' })
      database.create({ name: 'Warran Smith', email: 'warran@damon.com' })

      pager.run

      expect(output.string).to match(/(warran@damon.com)[\s\w:-]+(warran@yahoo.com)/)
    end

    it 'prints a header with initail of first contact name' do
      database.create({ name: 'Adam Smith' })

      pager.run

      expect(output.string).to match(/\sA\n/)
    end

    it 'prints all contacts, includes a header before if the initail of a contact changes' do
      gap = '[\s\w:-]+'

      database.create({ name: 'Adam Smith' })
      database.create({ name: 'Arron Davies' })
      database.create({ name: 'Ben Watts' })
      database.create({ name: 'Steven Rogers' })
      database.create({ name: 'Sue Peters' })

      pager.run

      expect(output.string).to match(/A
#{gap}(Adam Smith)
#{gap}(Arron Davies)
#{gap}B
#{gap}(Ben Watts)
#{gap}S
#{gap}(Steven Rogers)
#{gap}(Sue Peters)/)
    end

    it 'prompts user to press a key before continuing after contacts display' do
      gap = '[\s\w:-]+'

      database.create({ name: 'Adam Smith' })

      pager.run

      expect(output.string).to match(/(Adam Smith)#{gap}#{messages.continue_message}/)
    end

    it 'prompts user to press a key before continuing after no contacts message' do
      pager.run

      expect(output.string)
        .to match(/#{messages.no_contacts_message}\n#{messages.continue_message}/)
    end
  end
end

RSpec.describe 'with Array Database' do
  it_behaves_like 'a Pager', [DB::ArrayDatabase, nil]
end

RSpec.describe 'with File Database' do
  it_behaves_like 'a Pager', [DB::FileDatabase, Tempfile.new('test')]
end

RSpec.describe 'with SQLite3 Database' do
  it_behaves_like 'a Pager', [DB::SQLiteDatabase, ':memory:']
end
