# frozen_string_literal: true

class UserInterface
  ANOTHER_CONTACT_PROMPT = 'Add another contact? (y/n): '
  ANOTHER_SEARCH_PROMPT = 'Search again? (y/n): '
  CLEAR_COMMAND = "\033[H\033[2J"
  CONTACT_INDEX_PROMPT = 'Enter contact index: '
  CONTINUE_MESSAGE = 'Press any key to continue '
  ERROR_MESSAGE = 'Wrong input. Please try again: '
  NO_CONTACTS_MESSAGE = 'No contacts were found.'
  SEARCH_MESSAGE = 'Type search term: '
  MENU_MESSAGE = %{
    ---------------------

        CONTACT BOOK

    ---------------------


  1) List contacts
  2) Add contact
  3) Search contact
  4) Exit the program

  Choose a menu option: }

  FIELDS_TO_DISPLAY_NAMES = {
    name: 'Name: ',
    address: 'Address: ',
    phone: 'Phone: ',
    email: 'Email: ',
    notes: 'Notes: '
  }.freeze

  FIELDS_TO_PROMPTS = {
    name: 'Contact name: ',
    address: 'Contact address: ',
    phone: 'Contact phone: ',
    email: 'Contact email: ',
    notes: 'Contact notes: '
  }.freeze

  VALID_YES_NO_REPLY = /^[yn]$/i.freeze

  YES_REPLY = 'y'

  EXIT_CHOICE = 4

  def initialize(input, output, validator)
    @input = input
    @output = output
    @validator = validator
  end

  def menu_choice
    output.print CLEAR_COMMAND, MENU_MESSAGE
    collect_vaild_input { |user_input| validator.valid_choice?(user_input) }.to_i
  end

  def ask_for_fields
    FIELDS_TO_PROMPTS.each_with_object({}) do |(field, prompt), contact_details|
      output.print prompt

      contact_details[field] = collect_vaild_input { |user_input| validator.valid_field?(field, user_input) }
    end
  end

  def display_contact(contact)
    longest_display_name = FIELDS_TO_DISPLAY_NAMES.values.max_by(&:length)

    output.print "\n"
    contact.each do |field, value|
      output.puts FIELDS_TO_DISPLAY_NAMES[field].ljust(longest_display_name.length) + value
    end
  end

  def display_no_contacts_message
    output.puts NO_CONTACTS_MESSAGE
  end

  def add_another_contact?
    output.print ANOTHER_CONTACT_PROMPT
    collect_vaild_input { |user_input| validator.valid_yes_no_answer?(user_input) }.downcase == YES_REPLY
  end

  def display_letter_header(letter)
    output.print %(
------------------------------
              #{letter.upcase}
------------------------------
)
  end

  def continue
    output.print CONTINUE_MESSAGE
    input.getch
  end

  def search_term
    output.print SEARCH_MESSAGE
    collect_vaild_input { |user_input| validator.valid_string?(user_input) }
  end

  def search_again?
    output.print ANOTHER_SEARCH_PROMPT
    collect_vaild_input { |user_input| validator.valid_yes_no_answer?(user_input) }.downcase == YES_REPLY
  end

  def choose_contact(contacts)
    display_all_with_index(contacts)
    ask_for_index
  end

  private

  def ask_for_index
    output.print CONTACT_INDEX_PROMPT
  end

  def display_all_with_index(contacts)
    contacts.each_with_index do |contact, index|
      output.print "[#{index}]"
      display_contact(contact)
    end
  end

  def collect_vaild_input
    loop do
      user_input = input.gets.chomp
      break user_input if yield user_input

      output.print ERROR_MESSAGE
    end
  end

  attr_reader :input, :output, :validator
end
