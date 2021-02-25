# frozen_string_literal: true

require 'database_interface'

module DB
  class ArrayDatabase < DatabaseInterface
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

    def contact_at(index)
      all[index]
    end

    def update(index, new_data)
      all[index].update(new_data)
    end

    def delete(index)
      all.delete_at(index)
    end
  end
end
