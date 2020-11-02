# frozen_string_literal: true

require 'array_database'
require 'finder'
require 'user_interface'
require 'validator'

RSpec.describe Finder do
  describe '#run' do
    it 'askes user for a search_term' do
      database = ArrayDatabase.new
      input = StringIO.new('term')
      output = StringIO.new
      validator = Validator.new
      user_interface = UserInterface.new(input, output, validator)
      finder = described_class.new(user_interface, database)

      finder.run

      expect(output.string).to include(UserInterface::SEARCH_MESSAGE)
    end

    it 'prints message if no contacts are found' do
      database = ArrayDatabase.new
      input = StringIO.new('term')
      output = StringIO.new
      validator = Validator.new
      user_interface = UserInterface.new(input, output, validator)
      finder = described_class.new(user_interface, database)

      database.create({
                        name: 'Matt Damon',
                        address: 'Some address',
                        phone: '08796564231',
                        email: 'matt@damon.com',
                        notes: 'I think he has an Oscar'
                      })

      finder.run

      expect(output.string).to include(UserInterface::NO_CONTACTS_MESSAGE)
    end
  end
end
