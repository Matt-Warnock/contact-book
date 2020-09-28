# frozen_string_literal: true

class Creator
  def initialize(user_interface, database)
    @database = database
    @user_interface = user_interface
  end

  def run
    contact_details = user_interface.ask_for_fields
    database.create(contact_details)
    user_interface.display(contact_details)
  end

  private

  attr_reader :database, :user_interface
end
