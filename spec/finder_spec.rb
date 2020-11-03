# frozen_string_literal: true

require 'array_database'
require 'finder'
require 'user_interface'
require 'validator'

RSpec.describe Finder do
  describe '#run' do
    let(:database) { ArrayDatabase.new }
    let(:output) { StringIO.new }
    let(:validator) { Validator.new }

    it 'askes user for a search_term' do
      input = StringIO.new('term')
      user_interface = UserInterface.new(input, output, validator)
      finder = described_class.new(user_interface, database)

      finder.run

      expect(output.string).to include(UserInterface::SEARCH_MESSAGE)
    end

    it 'prints message if no contacts are found' do
      input = StringIO.new('term')
      user_interface = UserInterface.new(input, output, validator)
      finder = described_class.new(user_interface, database)

      database.create(test_contact)

      finder.run

      expect(output.string).to include(UserInterface::NO_CONTACTS_MESSAGE)
    end

    it 'does not print a no contacts message if contacts are found' do
      input = StringIO.new('damon')
      user_interface = UserInterface.new(input, output, validator)
      finder = described_class.new(user_interface, database)

      database.create(test_contact)

      finder.run

      expect(output.string).not_to include(UserInterface::NO_CONTACTS_MESSAGE)
    end

    it 'prints contacts if any are found' do
      input = StringIO.new('damon')
      user_interface = UserInterface.new(input, output, validator)
      finder = described_class.new(user_interface, database)

      database.create(test_contact)

      finder.run

      expect(output.string).to include(%(
Name:    Matt Damon
Address: Some address
Phone:   08796564231
Email:   matt@damon.com
Notes:   I think he has an Oscar
))
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
