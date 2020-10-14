# frozen_string_literal: true

class ArrayDatabase
  attr_reader :all

  def initialize
    @all = []
  end

  def create(contact)
    all << contact
  end

  def count
    all.length
  end

  def no_contacts?
    all.empty?
  end
end
