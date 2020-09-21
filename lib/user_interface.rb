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

  NAME_PROMPT = 'Contact name: '
  ADDRESS_PROMPT = 'Contact address: '
  PHONE_PROMPT = 'Contact phone: '
  EMAIL_PROMPT = 'Contact email: '
  NOTES_PROMPT = 'Contact notes: '

  FIELDS_TO_PROMPTS = {
    name: NAME_PROMPT,
    address: ADDRESS_PROMPT,
    phone: PHONE_PROMPT,
    email: EMAIL_PROMPT,
    notes: NOTES_PROMPT
  }.freeze

  FIELDS_TO_MATCHES = {

    phone: /^\d{11}$/,
    email: /@/
  }.freeze

  def initialize(input, output)
    @input = input
    @output = output
  end

  def run
    output.print CLEAR_COMMAND, MENU_MESSAGE
    user_input = ''

    loop do
      user_input = input.gets.chomp
      break if valid_choise?(user_input)

      output.print ERROR_MESSAGE
    end
    user_input.to_i
  end

  def ask_for_fields
    contact_details = {}
    FIELDS_TO_PROMPTS.each do |field, prompt|
      output.puts prompt

      loop do
        contact_details[field] = input.gets.chomp
        break if vaild_input?(contact_details, field)

        output.print ERROR_MESSAGE
      end
    end
    contact_details
  end

  private

  def valid_choise?(option)
    option.match?(/^\d$/) && option == '1'
  end

  def vaild_input?(contact_details, field)
    contact_details[field].match?(FIELDS_TO_MATCHES.fetch(field, /\w+/))
  end

  attr_reader :input, :output
end
