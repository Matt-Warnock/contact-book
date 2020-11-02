# frozen_string_literal: true

class Finder
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  def run
    search_result = database.search(user_interface.search_term)

    user_interface.display_no_contacts_message unless search_result.any?
  end

  private

  attr_reader :user_interface, :database
end
