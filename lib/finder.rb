# frozen_string_literal: true

class Finder
  def initialize(user_interface, database)
    @user_interface = user_interface
    @database = database
  end

  def run
    user_interface.search_term
  end

  private

  attr_reader :user_interface, :database
end
