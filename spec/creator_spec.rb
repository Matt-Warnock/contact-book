# frozen_string_literal: true

require 'creator'

RSpec.describe Creator do
  describe '#run' do
    it 'tells the UI to ask for contact details' do
      ui = double('UserInterface', ask_for_fields: nil)
      database = double('ArrayDatabase', create: nil)
      creator = described_class.new(ui, database)

      creator.run

      expect(ui).to have_received(:ask_for_fields).once
    end

    it 'tells the database to add the contact returned by the UI' do
      ui = double('UserInterface', ask_for_fields: test_details)
      database = double('ArrayDatabase', create: nil)
      creator = described_class.new(ui, database)

      creator.run

      expect(database).to have_received(:create).with(test_details)
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
