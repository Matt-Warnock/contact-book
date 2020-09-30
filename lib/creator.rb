# frozen_string_literal: true

class Creator
  def initialize(user_interface, database)
    @database = database
    @user_interface = user_interface
  end

  def run
    loop do
      contact_details = user_interface.ask_for_fields

      database.create(contact_details)
      user_interface.display(contact_details)
      break unless user_interface.add_another_contact?
    end
  end

  private

  attr_reader :database, :user_interface
end
