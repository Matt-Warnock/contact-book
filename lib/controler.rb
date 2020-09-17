# frozen_string_literal: true

class Controler
  def initialize(user_interface, actions)
    @user_interface = user_interface
    @actions = actions
  end

  def start
    actions[user_interface.run - 1].run
  end

  private

  attr_reader :user_interface, :actions
end
