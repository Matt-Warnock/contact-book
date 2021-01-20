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
      create_json_contact

      expect(database.all).to eq([test_details])
    end

    it 'return an empty array if file is empty' do
      expect(database.all).to eq([])
    end
  end

  describe '#database_empty?' do
    it 'returns false when contacts are present' do
      create_json_contact

      expect(database.database_empty?).to eq(false)
    end

    it 'returns true when no contacts are present' do
      expect(database.database_empty?).to eq(true)
    end
  end

  def create_json_contact
    file.write JSON.generate([test_details])
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
