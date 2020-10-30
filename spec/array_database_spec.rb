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

  describe '#database_empty?' do
    it 'returns false if array database has any contacts' do
      array_database = described_class.new

      array_database.create(test_details)

      expect(array_database.database_empty?).to eq(false)
    end

    it 'returns true if array database is empty' do
      array_database = described_class.new

      expect(array_database.database_empty?).to eq(true)
    end
  end

  describe '#search' do
    it 'returns any contacts that matches string given' do
      second_contact = {
        name: 'Oscar Wilde',
        address: 'Paris',
        phone: '00000000000',
        email: 'oscar@wilde.com',
        notes: 'I think he has an oscar'
      }
      third_contact = {
        name: 'Matt Camron',
        address: 'Seattle',
        phone: '00450400012',
        email: 'matt@pearjam.com',
        notes: 'amazing drummer'
      }
      array_database = described_class.new

      array_database.create(test_details)
      array_database.create(second_contact)
      array_database.create(third_contact)

      result = array_database.search('oscar')

      expect(result).to eq([test_details, second_contact])
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
