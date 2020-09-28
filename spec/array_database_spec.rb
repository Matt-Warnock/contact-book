# frozen_string_literal: true

require 'array_database'

RSpec.describe ArrayDatabase do
  it 'collects a contact hash into the array' do
    user_interface = double('UserInterface', ask_for_fields: test_details)
    array_database = described_class.new

    array_database.create(user_interface.ask_for_fields)

    expect(array_database.all[0]).to eq(test_details)
  end

  it 'count the amount of contacts in array' do
    user_interface = double('UserInterface', ask_for_fields: test_details)
    array_database = described_class.new

    array_database.create(user_interface.ask_for_fields)
    array_database.create(user_interface.ask_for_fields)

    expect(array_database.count).to eq(2)
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
