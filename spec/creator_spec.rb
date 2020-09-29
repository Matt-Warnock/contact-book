# frozen_string_literal: true

require 'creator'

RSpec.describe Creator do
  describe '#run' do
    let(:database) { double('ArrayDatabase', create: nil) }
    let(:ui) { double('UserInterface', ask_for_fields: test_details, display: nil, add_another_contact?: false) }

    it 'tells the UI to ask for contact details' do
      creator = described_class.new(ui, database)

      creator.run

      expect(ui).to have_received(:ask_for_fields).once
    end

    it 'tells the database to add the contact returned by the UI' do
      creator = described_class.new(ui, database)

      creator.run

      expect(database).to have_received(:create).with(test_details)
    end

    it 'tells the user interface to display the contact that was added' do
      creator = described_class.new(ui, database)

      creator.run

      expect(ui).to have_received(:display).with(test_details)
    end

    it 'tells the user interface to ask the user if they want to add another contact' do
      creator = described_class.new(ui, database)

      creator.run

      expect(ui).to have_received(:add_another_contact?).once
    end

    it 'repeats the previous steps if the user wants to add another contact' do
      allow(ui).to receive(:add_another_contact?).and_return(true, false)

      creator = described_class.new(ui, database)

      creator.run

      expect(ui).to have_received(:ask_for_fields).twice
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
