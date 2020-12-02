# frozen_string_literal: true

class Updater
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  attr_reader :user_interface, :database

  def run
    user_interface.choose_contact(database.all)
  end
end
