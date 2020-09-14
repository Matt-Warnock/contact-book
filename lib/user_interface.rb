# frozen_string_literal: true

class UserInterface
  MENU_MESSAGE = "\n---------------------\n\n\s\s\s\sCONTACT BOOK\n\n---------------------\n
  \n1) Exit the program\n\nChoose a menu option: "

  def initialize(input, output)
    @input = input
    @output = output
  end

  def run
    output.print MENU_MESSAGE
  end

  private

  attr_reader :input, :output
end
