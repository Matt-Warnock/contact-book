# frozen_string_literal: true

require 'creator'

RSpec.describe Creator do
  describe '#run' do
    it 'tells the UI to ask for contact details' do
      ui = double('UserInterface', ask_for_fields: nil)
      creator = described_class.new(ui)

      creator.run

      expect(ui).to have_received(:ask_for_fields).once
    end
  end
end
