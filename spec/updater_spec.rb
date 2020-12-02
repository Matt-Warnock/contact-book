# frozen_string_literal: true

require 'array_database'
require 'constants'
require 'updater'
require 'user_interface'
require 'validator'

RSpec.describe Updater do
  let(:database) { ArrayDatabase.new }
  let(:input) { StringIO.new(quick_exit_responces) }
  let(:output) { StringIO.new }
  let(:quick_exit_responces) { "0\nname\nirrelevant\nn\nn\n" }
  let(:user_interface) { UserInterface.new(input, output, validator) }
  let(:validator) { Validator.new }

  describe '#run' do
    before(:each) { database.create(test_details) }

    it 'asks the user for a contact to update' do
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::CONTACT_INDEX_PROMPT)
    end

    it 'asks the user which field it wants to update and the value for it' do
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::FIELD_CHOICE_PROMPT, Constants::FIELDS_TO_PROMPTS[:name])
    end

    it 'displays the contact with the data updated' do
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include("Name:    irrelevant\nAddress: Some address")
    end

    it 'asks the user if they want to edit another field' do
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::ANOTHER_EDIT_PROMPT)
    end

    it 'collects another field and value if they want to edit another field' do
      input = StringIO.new("0\nname\nirrelevant\ny\naddress\nirrelevant\nn\nn\n")
      user_interface = UserInterface.new(input, output, validator)
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string.scan(Constants::FIELD_CHOICE_PROMPT).length).to eq(2)
    end

    it 'asks if they want to edit another contact if they do not want to edit another field' do
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string).to include(Constants::ANOTHER_UPDATE_PROMPT)
    end

    it 'asks for another contact index if they want to edit another contact' do
      input = StringIO.new("0\nname\nirrelevant\ny\naddress\nirrelevant\nn\ny\n" + quick_exit_responces)
      user_interface = UserInterface.new(input, output, validator)
      updater = described_class.new(user_interface, database)

      updater.run

      expect(output.string.scan(Constants::CONTACT_INDEX_PROMPT).length).to eq(2)
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
