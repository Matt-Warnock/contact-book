# frozen_string_literal: true

module Actions
  class Terminator
    def initialize(user_interface, database)
      @user_interface = user_interface
      @database = database
    end

    def run
      loop do
        return handle_empty_database if database.database_empty?

        delete_contact
        break unless user_interface.delete_another_contact?
      end
    end

    private

    def delete_contact
      index = user_interface.choose_contact(database.all)
      contact = database.contact_at(index)

      return unless user_interface.delete?(contact)

      database.delete(index)
      user_interface.display_deletion_message
    end

    def handle_empty_database
      user_interface.display_no_contacts_message
      user_interface.continue
    end

    attr :user_interface, :database
  end
end
