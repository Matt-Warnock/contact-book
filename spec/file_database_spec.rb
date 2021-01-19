# frozen_string_literal: true

require 'file_database'
require 'tempfile'

RSpec.describe FileDatabase do
  let(:file) { Tempfile.open('test') }
  let(:database) { described_class.new(file) }

  after(:each) { file.unlink }

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
    it 'returns true when contacts are present' do
      create_json_contact

      expect(database.database_empty?).to eq(true)
    end

    it 'returns false when now contacts are present' do
      expect(database.database_empty?).to eq(false)
    end
  end

  def create_json_contact
    file.write JSON.generate([test_details])
    file.close
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
