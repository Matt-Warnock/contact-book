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
      page_all_contacts
    end
  end

  private

  def alphabetize_contacts
    database.all.sort { |a, b| a[:name] == b[:name] ? a[:email] <=> b[:email] : a[:name] <=> b[:name] }
  end

  def page_all_contacts
    page_index = ''

    alphabetize_contacts.each do |contact|
      name_initial = contact[:name].chr

      user_interface.display_letter_header(name_initial) unless name_initial == page_index
      user_interface.display_contact(contact)
      page_index = name_initial
    end
  end

  attr_reader :database, :user_interface
end
