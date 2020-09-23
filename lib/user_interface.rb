# frozen_string_literal: true

class UserInterface
  CLEAR_COMMAND = "\033[H\033[2J"
  ERROR_MESSAGE = 'Wrong input. Please try again: '
  MENU_MESSAGE = %{
    ---------------------

        CONTACT BOOK

    ---------------------


  1) Exit the program

  Choose a menu option: }

  FIELDS_TO_FIELD_NAMES = {
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

  def initialize(input, output)
    @input = input
    @output = output
  end

  def menu_choice
    output.print CLEAR_COMMAND, MENU_MESSAGE
    user_input = ''

    loop do
      user_input = input.gets.chomp
      break if valid_choice?(user_input)

      output.print ERROR_MESSAGE
    end
    user_input.to_i
  end

  def ask_for_fields
    FIELDS_TO_PROMPTS.each_with_object({}) do |(field, prompt), contact_details|
      output.puts prompt

      loop do
        contact_details[field] = input.gets.chomp
        break if vaild_field?(field, contact_details[field])

        output.print ERROR_MESSAGE
      end
    end
  end

  def display_contact(contact_hash)
    max_field_name = FIELDS_TO_FIELD_NAMES.values.max(1) { |a, b| a.length <=> b.length }[0]

    contact_hash.each do |field, value|
      output.puts FIELDS_TO_FIELD_NAMES[field].ljust(max_field_name.length) + value
    end
  end

  private

  def valid_choice?(option)
    option.match?(/^\d$/) && option == '1'
  end

  def vaild_field?(field, value)
    {
      phone: vaild_number?(value),
      email: valid_email?(value)
    }.fetch(field, true)
  end

  def vaild_number?(value)
    value.match?(/^\d{11}$/)
  end

  def valid_email?(value)
    value.match?(/@/)
  end

  attr_reader :input, :output
end
