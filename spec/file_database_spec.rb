# frozen_string_literal: true

require 'file_database'
require 'tempfile'

RSpec.describe FileDatabase do
  let(:file) { Tempfile.open('test') }
  let(:database) { described_class.new(file) }

  after(:each) do
    file.close
    file.unlink
  end

  describe '#all' do
    it 'reads all contacts in a json file to ruby' do
      file.write create_json_contact

      expect(database.all).to eq([test_details])
    end

    it 'return an empty array if file is empty' do
      expect(database.all).to eq([])
    end
  end

  describe '#database_empty?' do
    it 'returns false when contacts are present' do
      file.write create_json_contact

      expect(database.database_empty?).to eq(false)
    end

    it 'returns true when no contacts are present' do
      expect(database.database_empty?).to eq(true)
    end
  end

  describe '#create' do
    it 'adds a contact to the database file in valid json' do
      database.create(test_details)
      file.rewind

      expect(file.read).to eq(create_json_contact)
    end

    it 'adds contact to the end of the files array' do
      database.create({ name: 'Matt' })
      database.create({ name: 'John' })

      expect(database.all.last.values).to include('John')
    end
  end

  describe '#count' do
    it 'returns the size of file array as a number' do
      database.create(test_details)
      database.create(test_details)

      expect(database.count).to eq(2)
    end

    it 'returns zero integer when array is empty' do
      expect(database.count).to eq(0)
    end
  end

  describe '#contact_at' do
    it 'takes an index and returns the contact in that index' do
      database.create(test_details)
      database.create(second_contact)

      expect(database.contact_at(0)).to eq(test_details)
    end
  end

  describe '#update' do
    it 'updates the indexed contact in file with a feild/value pair provided' do
      database.create(test_details)

      database.update(0, { name: 'John' })

      expect(database.all.first[:name]).to eq('John')
    end
  end

  describe '#delete' do
    it 'deletes contact in index from file' do
      database.create(test_details)
      database.create(second_contact)

      database.delete(0)

      expect(database.all[0]).to_not eq(test_details)
    end
  end

  def create_json_contact
    JSON.generate([test_details])
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
