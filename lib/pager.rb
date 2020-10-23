# frozen_string_literal: true

class Pager
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  def run
    if database.database_empty?
      user_interface.display_no_contacts_message
    else
      page_all_contacts
    end
  end

  private

  attr_reader :database, :user_interface

  def sorted_contacts
    database.all.sort_by { |contact| [contact[:name], contact[:email]] }
  end

  def page_all_contacts
    page_index = ''

    sorted_contacts.each do |contact|
      name_initial = contact[:name].chr

      user_interface.display_letter_header(name_initial) unless name_initial == page_index
      user_interface.display_contact(contact)
      page_index = name_initial
    end
  end
end
