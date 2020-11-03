# frozen_string_literal: true

class Finder
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  def run
    loop do
      search_result = database.search(user_interface.search_term)
      handle_result(search_result)
      break unless user_interface.search_again?
    end
  end

  private

  def handle_result(search_result)
    user_interface.display_no_contacts_message unless search_result.any?
    search_result.each { |contact| user_interface.display_contact(contact) }
  end

  attr_reader :user_interface, :database
end
