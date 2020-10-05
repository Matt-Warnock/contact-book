# frozen_string_literal: true

class UserInterface
  ANOTHER_CONTACT_PROMPT = 'Add another contact? (y/n): '
  CLEAR_COMMAND = "\033[H\033[2J"
  ERROR_MESSAGE = 'Wrong input. Please try again: '
  MENU_MESSAGE = %{
    ---------------------

        CONTACT BOOK

    ---------------------


  1) Add contact
  2) Exit the program

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

  YES_REPLY = 'y'

  EXIT_CHOICE = 2

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
      output.puts prompt

      contact_details[field] = collect_vaild_input { |user_input| validator.valid_field?(field, user_input) }
    end
  end

  def display_contact(contact)
    longest_display_name = FIELDS_TO_DISPLAY_NAMES.values.max_by(&:length)

    contact.each do |field, value|
      output.puts FIELDS_TO_DISPLAY_NAMES[field].ljust(longest_display_name.length) + value
    end
  end

  def add_another_contact?
    output.print ANOTHER_CONTACT_PROMPT
    collect_vaild_input { |user_input| validator.valid_yes_no_answer?(user_input) }.downcase == YES_REPLY
  end

  private

  def collect_vaild_input
    loop do
      user_input = input.gets.chomp
      break user_input if yield user_input

      output.print ERROR_MESSAGE
    end
  end

  attr_reader :input, :output, :validator
end
