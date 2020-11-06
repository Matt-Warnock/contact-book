# frozen_string_literal: true

require 'constants'

class UserInterface
  def initialize(input, output, validator)
    @input = input
    @output = output
    @validator = validator
  end

  def menu_choice
    output.print Constants::CLEAR_COMMAND, Constants::MENU_MESSAGE
    collect_vaild_input { |user_input| validator.valid_choice?(user_input) }.to_i
  end

  def ask_for_fields
    Constants::FIELDS_TO_PROMPTS.each_with_object({}) do |(field, prompt), contact_details|
      output.print prompt

      contact_details[field] = collect_vaild_input { |user_input| validator.valid_field?(field, user_input) }
    end
  end

  def display_contact(contact)
    longest_display_name = Constants::FIELDS_TO_DISPLAY_NAMES.values.max_by(&:length)

    output.print "\n"
    contact.each do |field, value|
      output.puts Constants::FIELDS_TO_DISPLAY_NAMES[field].ljust(longest_display_name.length) + value
    end
  end

  def display_no_contacts_message
    output.puts Constants::NO_CONTACTS_MESSAGE
  end

  def add_another_contact?
    output.print Constants::ANOTHER_CONTACT_PROMPT
    collect_vaild_input { |user_input| validator.valid_yes_no_answer?(user_input) }.downcase == Constants::YES_REPLY
  end

  def display_letter_header(letter)
    output.print %(
------------------------------
              #{letter.upcase}
------------------------------
)
  end

  def continue
    output.print Constants::CONTINUE_MESSAGE
    input.getch
  end

  def search_term
    output.print Constants::SEARCH_MESSAGE
    collect_vaild_input { |user_input| validator.valid_string?(user_input) }
  end

  def search_again?
    output.print Constants::ANOTHER_SEARCH_PROMPT
    collect_vaild_input { |user_input| validator.valid_yes_no_answer?(user_input) }.downcase == Constants::YES_REPLY
  end

  def choose_contact(contacts)
    display_all_with_index(contacts)
    ask_for_index(contacts.length).to_i
  end

  def edit_field(contact)
    display_contact(contact)
    output.print Constants::EDIT_CONTACT_PROMPT
    collect_vaild_input { |user_input| validator.valid_field_name?(user_input) }
  end

  private

  def ask_for_index(array_length)
    output.print Constants::CONTACT_INDEX_PROMPT
    collect_vaild_input { |user_input| validator.valid_index?(user_input, array_length) }
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

      output.print Constants::ERROR_MESSAGE
    end
  end

  attr_reader :input, :output, :validator
end
