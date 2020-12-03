# frozen_string_literal: true

class Updater
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  attr_reader :user_interface, :database

  def run
    if database.database_empty?
      user_interface.display_no_contacts_message
      user_interface.continue
      return
    end
    update_contact
  end

  private

  def edit_contact(contact_index)
    contact = database.contact_at(contact_index)

    loop do
      new_data = user_interface.edit_field(contact)

      database.update(contact_index, new_data)
      user_interface.display_contact(contact)
      break unless user_interface.update_another_field?
    end
  end

  def update_contact
    loop do
      contact_index = user_interface.choose_contact(database.all)
      edit_contact(contact_index)
      break unless user_interface.update_another_contact?
    end
  end
end
