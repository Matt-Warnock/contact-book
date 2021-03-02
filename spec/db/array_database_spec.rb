# frozen_string_literal: true

require 'db/array_database'

RSpec.describe DB::ArrayDatabase do
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

  describe '#contact_at' do
    it 'takes an index as an argument and returns the contact in that index' do
      array_database = described_class.new

      array_database.create(test_details)
      array_database.create(second_contact)

      result = array_database.contact_at(0)

      expect(result).to eq(test_details)
    end
  end

  describe '#update' do
    it 'updates the contact in the index provided with the field/value pair provided' do
      array_database = described_class.new

      array_database.create(test_details)
      array_database.update(0, { address: 'New address' })

      expect(array_database.all.first[:address]).to eq('New address')
    end
  end

  describe '#delete' do
    it 'deletes contact from index provided' do
      array_database = described_class.new

      array_database.create(test_details)
      array_database.create(second_contact)

      array_database.delete(0)

      expect(array_database.all[0]).to_not eq(test_details)
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
