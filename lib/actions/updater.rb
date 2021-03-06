# frozen_string_literal: true

module Actions
  class Updater
    def initialize(user_interface, database)
      @user_interface = user_interface
      @database = database
    end

    attr_reader :user_interface, :database

    def run
      return handle_empty_database if database.database_empty?

      update_contacts
    end

    private

    def edit_contact_fields(contact_index)
      loop do
        new_data = user_interface.edit_field

        database.update(contact_index, new_data)
        user_interface.display_contact(database.contact_at(contact_index))
        break unless user_interface.update_another_field?
      end
    end

    def update_contacts
      loop do
        contact_index = user_interface.choose_contact(database.all)

        user_interface.display_contact(database.contact_at(contact_index))
        edit_contact_fields(contact_index)
        break unless user_interface.update_another_contact?
      end
    end

    def handle_empty_database
      user_interface.display_no_contacts_message
      user_interface.continue
    end
  end
end
