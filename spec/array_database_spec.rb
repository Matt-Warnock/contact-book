# frozen_string_literal: true

require 'array_database'

RSpec.describe ArrayDatabase do
  describe '#create' do
    it 'collects a contact into the array' do
      array_database = described_class.new

      array_database.create(test_details)

      expect(array_database.all[0]).to eq(test_details)
    end
  end

  describe '#count' do
    it 'counts the amount of contacts in array' do
      array_database = described_class.new

      array_database.create(test_details)
      array_database.create(test_details)

      expect(array_database.count).to eq(2)
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
