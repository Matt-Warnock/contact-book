# frozen_string_literal: true

require 'json'

class FileDatabase
  def initialize(file_dir)
    @file = File.open(file_dir, 'r')
  end

  def all
    file.rewind
    convert_from_json(file.read)
  end

  def database_empty?
    all.any?
  end

  private

  def convert_from_json(contacts)
    return [] if contacts.empty?

    JSON.parse(contacts, { symbolize_names: true })
  end

  attr_reader :file
end
