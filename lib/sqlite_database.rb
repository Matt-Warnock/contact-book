# frozen_string_literal: true

require 'database_interface'
require 'sqlite3'

class SQLiteDatabase < DatabaseInterface
  def initialize(file_path)
    @db = SQLite3::Database.new(file_path)
    db.execute 'CREATE TABLE IF NOT EXISTS contacts
                (name TEXT, address TEXT, phone TEXT, email TEXT, notes TEXT);'
  end

  def all
    contacts = []
    db.query 'SELECT * FROM contacts' do |table|
      table.each_hash { |contact| contacts << contact.transform_keys(&:to_sym) }
    end
    contacts
  end

  def database_empty?
    all.empty?
  end

  def create(contact)
    db.execute('INSERT INTO contacts (name, address, phone, email, notes)
                VALUES (?, ?, ?, ?, ?)', contact.values)
  end

  private

  attr_reader :db
end
