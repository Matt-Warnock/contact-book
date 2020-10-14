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
      database.create(first_test_details)

      pager.run

      expect(output.string).to_not eq(UserInterface::NO_CONTACTS_MESSAGE)
    end

    it 'sorts contacts into aphabetical order according to name' do
      database.create(first_test_details)
      database.create(second_test_details)

      pager.run

      expect(database.all).to eq([second_test_details, first_test_details])
    end

    it 'aphabeticaly sorts same name contacts by email' do
      database.create(same_name_test_details)
      database.create(first_test_details)

      pager.run

      expect(database.all).to eq([first_test_details, same_name_test_details])
    end
  end

  def first_test_details
    {
      name: 'Warran Smith',
      address: 'Some address',
      phone: '08796564231',
      email: 'warran@damon.com',
      notes: 'some guy I know'
    }
  end

  def second_test_details
    {
      name: 'Matt Damon',
      address: 'Some address',
      phone: '08796564231',
      email: 'matt@damon.com',
      notes: 'I think he has an Oscar'
    }
  end

  def same_name_test_details
    {
      name: 'Warran Smith',
      address: 'Some address',
      phone: '08796564231',
      email: 'warran@yahoo.com',
      notes: 'a diffrent guy I know'
    }
  end
end
