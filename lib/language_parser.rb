# frozen_string_literal: true

require 'yaml'

class LanguageParser
  def initialize(file_path)
    @file_path = Pathname.new(file_path)
  end

  def messages
    @messages ||= JSON.parse(YAML.load_file(file_path).to_json, object_class: OpenStruct)
  rescue Errno::ENOENT
    raise 'Invalid or missing .yml file'
  end

  private

  attr_reader :file_path
end
