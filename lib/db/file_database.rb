# frozen_string_literal: true

require 'db/database_interface'
require 'json'

module DB
  class FileDatabase < DB::DatabaseInterface
    def initialize(file)
      @file = file
    end

    def all
      file.rewind
      convert_json(file.read)
    end

    def database_empty?
      all.empty?
    end

    def create(contact)
      file_array = all.push(contact)
      write_to_file(file_array)
    end

    def count
      all.length
    end

    def contact_at(index)
      all[index]
    end

    def update(index, new_data)
      file_array = all

      file_array[index].update(new_data)
      write_to_file(file_array)
    end

    def delete(index)
      file_array = all

      file_array.delete_at(index)
      write_to_file(file_array)
    end

    def search(term)
      all.find_all do |contact|
        contact.any? { |_, value| value.match?(/#{term}/i) }
      end
    end

    private

    attr_reader :file

    def write_to_file(file_array)
      file.rewind
      file.truncate(0)
      file << file_array.to_json
      file.flush
    end

    def convert_json(contacts)
      return [] if contacts.empty?

      JSON.parse(contacts, { symbolize_names: true })
    end
  end
end
