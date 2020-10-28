# frozen_string_literal: true

require 'array_database'
require 'pager'
require 'user_interface'
require 'validator'

RSpec.describe Pager do
  let(:database) { ArrayDatabase.new }
  let(:input) { StringIO.new }
  let(:output) { StringIO.new }
  let(:pager) { Pager.new(user_interface, database) }
  let(:user_interface) { UserInterface.new(input, output, validator) }
  let(:validator) { Validator.new }

  describe '#run' do
    it 'prints a message to the user if the database is empty' do
      pager.run

      expect(output.string).to include(UserInterface::NO_CONTACTS_MESSAGE)
    end

    it 'does not prints a message if the database has any contacts' do
      database.create({ name: 'Matt Damon' })

      pager.run

      expect(output.string).to_not include(UserInterface::NO_CONTACTS_MESSAGE)
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

      expect(output.string).to match(/#{gap}(Adam Smith)#{gap}#{UserInterface::CONTINUE_MESSAGE}/)
    end

    it 'prompts user to press a key before continuing after no contacts message' do
      pager.run

      expect(output.string).to match(/#{UserInterface::NO_CONTACTS_MESSAGE}#{UserInterface::CONTINUE_MESSAGE}/)
    end
  end
end
