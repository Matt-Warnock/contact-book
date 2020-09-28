# frozen_string_literal: true

class ArrayDatabase
  def initialize
    @all = []
  end

  attr_reader :all

  def create(contact)
    all << contact
  end
end
