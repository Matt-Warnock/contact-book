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

      expect(output.string).to eq(UserInterface::NO_CONTACTS_MESSAGE)
    end

    it 'does not prints a message if the database has any contacts' do
      database.create({ name: 'Matt Damon' })

      pager.run

      expect(output.string).to_not eq(UserInterface::NO_CONTACTS_MESSAGE)
    end

    it 'sorts contacts into aphabetical order according to name' do
      database.create({ name: 'Warran Smith' })
      database.create({ name: 'Matt Damon' })

      pager.run

      expect(database.all).to eq([{ name: 'Matt Damon' }, { name: 'Warran Smith' }])
    end

    it 'aphabeticaly sorts same name contacts by email' do
      contact_a = { name: 'Warran Smith',
                    email: 'warran@yahoo.com' }
      contact_b = { name: 'Warran Smith',
                    email: 'warran@damon.com' }

      database.create(contact_a)
      database.create(contact_b)

      pager.run

      expect(database.all).to eq([contact_b, contact_a])
    end

    it 'prints a header with initail of first contact name' do
      database.create({ name: 'Adam Smith' })

      pager.run

      expect(output.string).to include(letter_header('A'))
    end

    it 'prints a header each time the initail of a contact is diffrent from the last' do
      database.create({ name: 'Adam Smith' })
      database.create({ name: 'Arron Davies' })
      database.create({ name: 'Ben Watts' })
      database.create({ name: 'Sue Peters' })
      database.create({ name: 'Steven Rogers' })

      pager.run

      expect(output.string).to include(letter_header('A'), letter_header('B'), letter_header('S'))
    end
  end

  def letter_header(letter)
    %(
------------------------------
              #{letter}
------------------------------
)
  end
end
