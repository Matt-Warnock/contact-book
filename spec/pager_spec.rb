# frozen_string_literal: true

require 'array_database'
require 'pager'
require 'user_interface'
require 'validator'

RSpec.describe Pager do
  describe '#run' do
    it 'prints a message to the user if the database is empty' do
      database = ArrayDatabase.new
      input = StringIO.new
      output = StringIO.new
      validator = Validator.new
      user_interface = UserInterface.new(input, output, validator)
      pager = Pager.new(user_interface, database)

      pager.run

      expect(output.string).to eq(UserInterface::NO_CONTACTS_MESSAGE)
    end

    it 'does not prints a message if the database has any contacts' do
      database = ArrayDatabase.new
      input = StringIO.new
      output = StringIO.new
      validator = Validator.new
      user_interface = UserInterface.new(input, output, validator)
      pager = Pager.new(user_interface, database)

      database.create(test_details)

      pager.run

      expect(output.string).to_not eq(UserInterface::NO_CONTACTS_MESSAGE)
    end
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
