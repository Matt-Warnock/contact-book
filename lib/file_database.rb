# frozen_string_literal: true

require 'json'

class FileDatabase
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

    file.open.write JSON.generate(file_array)
    file.flush
  end

  private

  attr_reader :file

  def convert_json(contacts)
    return [] if contacts.empty?

    JSON.parse(contacts, { symbolize_names: true })
  end
end
