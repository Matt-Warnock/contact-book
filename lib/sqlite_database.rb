# frozen_string_literal: true

require 'database_interface'
require 'sqlite3'

class SQLiteDatabase < DatabaseInterface
  def initialize(file_path)
    @db = SQLite3::Database.new(file_path)
    db.execute 'CREATE TABLE IF NOT EXISTS contacts(name VARCHAR(10) NOT NULL,
                                                    address VARCHAR(30),
                                                    phone VARCHAR(11),
                                                    email VARCHAR(15) UNIQUE,
                                                    notes VARCHAR(50));'
  end

  def all
    query_results_to_hash_array('SELECT * FROM contacts')
  end

  def database_empty?
    all.empty?
  end

  def create(contact)
    row = contact.values_at(:name, :address, :phone, :email, :notes)
    db.execute('INSERT INTO contacts VALUES (?, ?, ?, ?, ?)', row)
  end

  def count
    all.length
  end

  def contact_at(index)
    db.query('SELECT * FROM contacts WHERE rowid = ?', (index + 1)) do |row|
      row.next_hash.transform_keys(&:to_sym)
    end
  end

  def update(index, new_data)
    new_data.each do |key, value|
      db.execute(''"UPDATE contacts SET #{key} = ? WHERE rowid = ?;"'', [value, index + 1])
    end
  end

  def delete(index)
    db.execute('DELETE FROM contacts WHERE rowid = ?', index + 1)
  end

  def search(term)
    query_results_to_hash_array(''"SELECT * FROM contacts WHERE name LIKE '%#{term}%' OR
                                                                address LIKE '%#{term}%' OR
                                                                phone LIKE '%#{term}%' OR
                                                                email LIKE '%#{term}%' OR
                                                                notes LIKE '%#{term}%';"'')
  end

  private

  def query_results_to_hash_array(sql)
    contacts = []
    db.query sql do |row|
      row.each_hash { |contact| contacts << contact.transform_keys(&:to_sym) }
    end
    contacts
  end

  attr_reader :db
end
