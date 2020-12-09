# frozen_string_literal: true

class Terminator
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  def run
    loop do
      if database.database_empty?
        user_interface.display_no_contacts_message
        user_interface.continue
        return
      end
      deletion_decision
      break unless user_interface.delete_another_contact?
    end
  end

  private

  def deletion_decision
    index = user_interface.choose_contact(database.all)
    contact = database.contact_at(index)

    return unless user_interface.delete?(contact)

    database.delete(index)
    user_interface.display_deletion_message
  end

  attr :user_interface, :database
end
