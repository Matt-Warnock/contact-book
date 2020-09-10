# frozen_string_literal: true

class UserInterface
  CLEAR_COMMAND = "\033[H\033[2J"
  MENU_MESSAGE = "\n---------------------\n\n\s\s\s\sCONTACT BOOK\n\n---------------------\n
  \n1) Exit the program\n\nChoose a menu option: "

  attr_reader :user_input

  def initialize(input, output)
    @input = input
    @output = output
  end

  def run
    output.write CLEAR_COMMAND
    output.print MENU_MESSAGE
    @user_input = input.gets.chomp
  end

  private

  attr_reader :input, :output
end
