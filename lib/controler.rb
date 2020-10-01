# frozen_string_literal: true

class Controler
  def initialize(user_interface, actions)
    @user_interface = user_interface
    @actions = actions
  end

  def start
    user_choice = user_interface.menu_choice

    actions[user_choice - 1].run
    user_interface.menu_choice unless user_choice == 2
  end

  private

  attr_reader :user_interface, :actions
end
