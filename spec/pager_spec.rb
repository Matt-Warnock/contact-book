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

    it 'prints all contacts, includes a header before if the initail of a contact changes' do
      contact_list = [{ name: 'Adam Smith' },
                      { name: 'Arron Davies' },
                      { name: 'Ben Watts' },
                      { name: 'Steven Rogers' },
                      { name: 'Sue Peters' }]

      database_double = double(ArrayDatabase, all: contact_list, no_contacts?: false)
      pager = Pager.new(user_interface, database_double)

      pager.run

      expect(output.string).to eq(letter_header('A') +
                                  contact_format('Adam Smith') +
                                  contact_format('Arron Davies') +
                                  letter_header('B') +
                                  contact_format('Ben Watts') +
                                  letter_header('S') +
                                  contact_format('Steven Rogers') +
                                  contact_format('Sue Peters'))
    end
  end

  def letter_header(letter)
    %(
------------------------------
              #{letter}
------------------------------
)
  end

  def contact_format(name)
    %(Name:    #{name}

)
  end
end
