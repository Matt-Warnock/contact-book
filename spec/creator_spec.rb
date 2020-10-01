# frozen_string_literal: true

require 'array_database'
require 'creator'

RSpec.describe Creator do
  describe '#run' do
    let(:creator) { described_class.new(ui, database) }
    let(:database) { ArrayDatabase.new }
    let(:ui) do
      double('UserInterface',
             ask_for_fields: test_details,
             display: nil,
             add_another_contact?: false)
    end

    it 'tells the UI to ask for contact details' do
      creator.run

      expect(ui).to have_received(:ask_for_fields).once
    end

    it 'tells the database to add the contact returned by the UI' do
      creator.run

      expect(database.all.first).to eq(test_details)
    end

    it 'tells the user interface to display the contact that was added' do
      creator.run

      expect(ui).to have_received(:display).with(test_details)
    end

    it 'tells the user interface to ask the user if they want to add another contact' do
      creator.run

      expect(ui).to have_received(:add_another_contact?).once
    end

    it 'repeats the previous steps if the user wants to add another contact' do
      allow(ui).to receive(:add_another_contact?).and_return(true, false)

      creator.run

      expect(database.all.count).to eq(2)
    end

    it 'finishes and returns control to the caller if the user does not want to add another contact' do
      expect(creator.run).to eq(nil)
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