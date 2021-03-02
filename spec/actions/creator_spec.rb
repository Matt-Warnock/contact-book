# frozen_string_literal: true

require 'db/array_database'
require 'actions/creator'
require 'db/file_database'
require 'db/sqlite_database'

RSpec.shared_examples 'a Creator' do |database_class, argument|
  describe '#run' do
    let(:creator) { Actions::Creator.new(ui, database) }
    let(:database) { argument ? database_class.new(argument) : database_class.new }
    let(:ui) do
      double('UserInterface',
             ask_for_fields: test_details,
             display_contact: nil,
             add_another_contact?: false)
    end

    after(:each) do
      if argument.instance_of?(Tempfile)
        argument.truncate(0)
        argument.rewind
      end
    end

    after(:all) do
      if argument.instance_of?(Tempfile)
        argument.close
        argument.unlink
      end
    end

    it 'tells the UI to ask for contact details' do
      creator.run

      expect(ui).to have_received(:ask_for_fields).once
    end

    it 'tells the database to add the contact returned by the UI' do
      creator.run

      expect(database.all.first).to include(test_details)
    end

    it 'tells the user interface to display the contact that was added' do
      creator.run

      expect(ui).to have_received(:display_contact).with(test_details)
    end

    it 'tells the user interface to ask the user if they want to add another contact' do
      creator.run

      expect(ui).to have_received(:add_another_contact?).once
    end

    it 'repeats the previous steps if the user wants to add another contact' do
      allow(ui).to receive(:add_another_contact?).and_return(true, false)
      allow(ui).to receive(:ask_for_fields).and_return(test_details, second_contact)

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

RSpec.describe 'with Array Database' do
  it_behaves_like 'a Creator', [DB::ArrayDatabase, nil]
end

RSpec.describe 'with File Database' do
  it_behaves_like 'a Creator', [DB::FileDatabase, Tempfile.new('test')]
end

RSpec.describe 'with sqlite3 database' do
  it_behaves_like 'a Creator', [DB::SQLiteDatabase, ':memory:']
end
