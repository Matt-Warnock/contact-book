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
  FIELDS_TO_PROMPTS = {
    name: NAME_PROMPT,
    address: ADDRESS_PROMPT
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
      break if valid?(user_input)

      output.print ERROR_MESSAGE
    end
    user_input.to_i
  end

  def ask_for_fields
    contact_details = {}
    output.puts FIELDS_TO_PROMPTS[:name]
    contact_details[:name] = input.gets.chomp
    output.puts FIELDS_TO_PROMPTS[:address]
    contact_details[:address] = input.gets.chomp
    contact_details
  end

  private

  def valid?(option)
    option.match?(/^\d$/) && option == '1'
  end

  attr_reader :input, :output
end
