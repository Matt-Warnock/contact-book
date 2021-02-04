# frozen_string_literal: true

class Controler
  def initialize(user_interface, actions, messages)
    @user_interface = user_interface
    @actions = actions
    @messages = messages
  end

  def start
    loop do
      user_choice = user_interface.menu_choice

      actions[user_choice - 1].run
      break if user_choice == messages.exit_choice
    end
  end

  private

  attr_reader :user_interface, :actions, :messages
end
