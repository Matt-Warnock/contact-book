# frozen_string_literal: true

require 'user_interface'

class Controler
  def initialize(user_interface, actions)
    @user_interface = user_interface
    @actions = actions
  end

  def start
    loop do
      user_choice = user_interface.menu_choice

      actions[user_choice - 1].run
      break if user_choice == UserInterface::EXIT_CHOICE
    end
  end

  private

  attr_reader :user_interface, :actions
end
