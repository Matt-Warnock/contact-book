# frozen_string_literal: true

class Creator
  def initialize(user_interface)
    @user_interface = user_interface
  end

  def run
    @user_interface.ask_for_fields
  end
end
