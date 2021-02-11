# frozen_string_literal: true

require 'sqlite_database'

RSpec.describe SQLiteDatabase do
  let(:database) { described_class.new('file::memory:?cache=shared') }
  let(:file) { SQLite3::Database.open('file::memory:?cache=shared') }

  before(:each) { database }
  after(:each) { file.execute 'DROP TABLE contacts' }

  describe '#all' do
    it 'return an empty array if invalid file path is given' do
      database = described_class.new('')
      expect(database.all).to eq([])
    end

    it 'returns all contacts in a sqlite file as array of hashs' do
      add_contact_to_file(test_details)
      add_contact_to_file(second_contact)

      expect(database.all).to eq([test_details, second_contact])
    end

    it 'return an empty array if file is empty' do
      expect(database.all).to eq([])
    end
  end

  describe '#database_empty?' do
    it 'returns false when contacts are present' do
      add_contact_to_file(test_details)

      expect(database.database_empty?).to eq(false)
    end

    it 'returns true when no contacts are present' do
      expect(database.database_empty?).to eq(true)
    end
  end

  describe '#create' do
    it 'adds a contact to the sql file' do
      database.create(test_details)

      result = file.query 'SELECT * FROM contacts' do |row|
        row.next_hash.transform_keys(&:to_sym)
      end

      expect(result).to eq(test_details)
    end

    it 'appends contacts to file' do
      database.create({ name: 'Matt' })
      database.create({ name: 'John' })

      expect(database.all.last.values).to include('John')
    end
  end

  describe '#count' do
    it 'returns the number of contacts in file as a number' do
      add_contact_to_file(test_details)
      add_contact_to_file(second_contact)

      expect(database.count).to eq(2)
    end

    it 'returns zero integer when file is empty' do
      expect(database.count).to eq(0)
    end
  end

  describe '#contact_at' do
    it 'takes an index and returns the contact in that index' do
      add_contact_to_file(test_details)
      add_contact_to_file(second_contact)

      expect(database.contact_at(0)).to eq(test_details)
    end
  end

  describe '#update' do
    xit 'updates the indexed contact in file with a feild/value pair provided' do
      add_contact_to_file(test_details)

      database.update(0, { name: 'John' })

      expect(database.all.first[:name]).to eq('John')
    end
  end

  describe '#delete' do
    xit 'deletes contact in index from file' do
      add_contact_to_file(test_details)
      add_contact_to_file(second_contact)

      database.delete(0)

      expect(database.all.first).to eq(second_contact)
    end
  end

  describe '#search' do
    xit 'returns any contacts that matches string given' do
      third_contact = {
        name: 'Matt Camron',
        address: 'Seattle',
        phone: '00450400012',
        email: 'matt@pearjam.com',
        notes: 'amazing drummer'
      }

      add_contact_to_file(test_details)
      add_contact_to_file(second_contact)
      add_contact_to_file(third_contact)

      result = database.search('oscar')

      expect(result).to eq([test_details, second_contact])
    end

    xit 'returns an empty array when no matches are found' do
      add_contact_to_file(test_details)

      result = database.search('irrelevant')

      expect(result).to eq([])
    end
  end

  def add_contact_to_file(contact)
    row = contact.values_at(:name, :address, :phone, :email, :notes)
    file.execute('INSERT INTO contacts VALUES (?, ?, ?, ?, ?)', row)
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
