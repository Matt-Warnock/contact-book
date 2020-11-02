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

  def database_empty?
    all.empty?
  end

  def search(term)
    all.find_all do |contact|
      contact.any? { |_, value| value.match?(/#{term}/i) }
    end
  end
end
