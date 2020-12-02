# frozen_string_literal: true

require 'array_database'
require 'constants'
require 'updater'
require 'user_interface'
require 'validator'

RSpec.describe Updater do
  let(:database) { ArrayDatabase.new }
  let(:output) { StringIO.new }
  let(:validator) { Validator.new }

  describe '#run' do
    before(:each) do
      database.create(test_details)
      database.create(second_contact)
    end

    it 'asks the user for a contact to update' do
      input = StringIO.new("0\n")
      user_interface = UserInterface.new(input, output, validator)
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::CONTACT_INDEX_PROMPT)
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
