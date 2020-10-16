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
      user_interface.display_letter_header(database.all[0][:name].chr)
    end
  end

  private

  def alphabetize_contacts
    database.all
            .sort! { |a, b| a[:name] != b[:name] ? a[:name] <=> b[:name] : a[:email] <=> b[:email] }
  end

  attr_reader :database, :user_interface
end
