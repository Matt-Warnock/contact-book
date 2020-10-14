# frozen_string_literal: true

class Pager
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  def run
    if database.no_contacts?
      user_interface.display_no_contacts_message
    else
      alphabetize_contacts
    end
  end

  private

  def alphabetize_contacts
    database.all.sort! { |a, b| a[:name].chr <=> b[:name].chr }
  end

  attr_reader :database, :user_interface
end
