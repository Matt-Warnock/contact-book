# frozen_string_literal: true

require 'array_database'
require 'constants'
require 'updater'
require 'user_interface'
require 'validator'

RSpec.describe Updater do
  let(:database) { ArrayDatabase.new }
  let(:input) { StringIO.new("0\nname\nirrelevant\nn\n") }
  let(:output) { StringIO.new }
  let(:validator) { Validator.new }

  describe '#run' do
    before(:each) do
      database.create(test_details)
      database.create(second_contact)
    end

    it 'asks the user for a contact to update' do
      user_interface = UserInterface.new(input, output, validator)
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::CONTACT_INDEX_PROMPT)
    end

    it 'asks the user which field it wants to update and the value for it' do
      user_interface = UserInterface.new(input, output, validator)
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::FIELD_CHOICE_PROMPT, Constants::FIELDS_TO_PROMPTS[:name])
    end

    it 'displays the contact with the data updated' do
      user_interface = UserInterface.new(input, output, validator)
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include("Name:    irrelevant\nAddress: Some address")
    end

    it 'asks the user if they want to edit another field' do
      user_interface = UserInterface.new(input, output, validator)
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::ANOTHER_EDIT_PROMPT)
    end

    it 'collects another field and value if they want to edit another field' do
      input = StringIO.new("0\nname\nirrelevant\ny\naddress\nirrelevant\nn\n")
      user_interface = UserInterface.new(input, output, validator)
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::ANOTHER_EDIT_PROMPT)
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
