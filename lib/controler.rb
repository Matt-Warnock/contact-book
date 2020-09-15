# frozen_string_literal: true

class Controler
  def initialize(user_interface)
    @user_interface = user_interface
  end

  def start
    @user_interface.run
  end
end
