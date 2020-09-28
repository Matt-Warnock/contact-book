# frozen_string_literal: true

require 'array_database'

RSpec.describe ArrayDatabase do
  it 'collects a contact hash into the array' do
    user_interface = double('UserInterface', ask_for_fields: test_details)
    array_database = described_class.new

    array_database.create(user_interface.ask_for_fields)

    contact_hash = array_database.all[0]

    expect(contact_hash).to eq(test_details)
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
