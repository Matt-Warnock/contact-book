# frozen_string_literal: true

require 'file_database'
require 'tempfile'

RSpec.describe FileDatabase do
  describe '#all' do
    it 'reads all contacts in a json file to ruby' do
      file = Tempfile.open('test')
      file.write JSON.generate([test_details])
      file.close

      database = described_class.new(file)

      expect(database.all).to eq([test_details])

      file.unlink
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
