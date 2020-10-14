# frozen_string_literal: true

class Pager
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  def run
    @user_interface.display_no_contacts_message unless @database.any?
  end
end
