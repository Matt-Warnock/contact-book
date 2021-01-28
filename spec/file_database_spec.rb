# frozen_string_literal: true

require 'file_database'

RSpec.describe FileDatabase do
  let(:file) { Tempfile.open('test') }
  let(:database) { described_class.new(file) }

  after(:each) do
    file.close
    file.unlink
  end

  describe '#all' do
    it 'reads all contacts in a json file to ruby' do
      file << [test_details].to_json

      expect(database.all).to eq([test_details])
    end

    it 'return an empty array if file is empty' do
      expect(database.all).to eq([])
    end
  end

  describe '#database_empty?' do
    it 'returns false when contacts are present' do
      file << [test_details].to_json

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

      expect(file.read).to eq([test_details].to_json)
    end

    it 'adds contact to the end of the files array' do
      database.create({ name: 'Matt' })
      database.create({ name: 'John' })

      expect(database.all.last.values).to include('John')
    end
  end

  describe '#count' do
    it 'returns the size of file array as a number' do
      file << [test_details, second_contact].to_json

      expect(database.count).to eq(2)
    end

    it 'returns zero integer when array is empty' do
      expect(database.count).to eq(0)
    end
  end

  describe '#contact_at' do
    it 'takes an index and returns the contact in that index' do
      file << [test_details, second_contact].to_json

      expect(database.contact_at(0)).to eq(test_details)
    end
  end

  describe '#update' do
    it 'updates the indexed contact in file with a feild/value pair provided' do
      file << [test_details].to_json

      database.update(0, { name: 'John' })

      expect(database.all.first[:name]).to eq('John')
    end
  end

  describe '#delete' do
    it 'deletes contact in index from file' do
      file << [test_details, second_contact].to_json

      database.delete(0)

      expect(database.all.first).to eq(second_contact)
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

      file << [test_details, second_contact, third_contact].to_json

      result = database.search('oscar')

      expect(result).to eq([test_details, second_contact])
    end

    it 'returns an empty array when no matches are found' do
      file << [test_details].to_json

      result = database.search('irrelevant')

      expect(result).to eq([])
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
