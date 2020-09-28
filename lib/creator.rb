# frozen_string_literal: true

class Creator
  def initialize(user_interface, database)
    @database = database
    @user_interface = user_interface
  end

  def run
    database.create(user_interface.ask_for_fields)
  end

  private

  attr_reader :database, :user_interface
end
