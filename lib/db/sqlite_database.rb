# frozen_string_literal: true

require 'db/database_interface'
require 'sqlite3'

module DB
  class SQLiteDatabase < DB::DatabaseInterface
    def initialize(file_path)
      @db = SQLite3::Database.new(file_path)
      create_table
    end

    def all
      query_results_to_hash_array('SELECT * FROM contacts')
    end

    def database_empty?
      all.empty?
    end

    def create(contact)
      contact.default = ''
      row = contact.values_at(:name, :address, :phone, :email, :notes)
      db.execute('INSERT INTO contacts(name, address, phone, email, notes)
      VALUES(?, ?, ?, ?, ?)', row)
    end

    def count
      all.length
    end

    def contact_at(index)
      db.query('SELECT * FROM contacts WHERE id = ?', index_to_id(index)) do |row|
        row.next_hash.transform_keys(&:to_sym)
      end
    end

    def update(index, new_data)
      db.execute("UPDATE contacts
        SET #{new_data.keys.first} = ?
        WHERE id = ?;", [new_data.values.first, index_to_id(index)])
    end

    def delete(index)
      db.execute('DELETE FROM contacts WHERE id = ?', index_to_id(index))
    end

    def search(term)
      query_results_to_hash_array("SELECT *
        FROM contacts
        WHERE name LIKE '%#{term}%'
        OR address LIKE '%#{term}%'
        OR phone LIKE '%#{term}%'
        OR email LIKE '%#{term}%'
        OR notes LIKE '%#{term}%';")
    end

    private

    def create_table
      db.execute 'CREATE TABLE IF NOT EXISTS contacts(
      id INTEGER PRIMARY KEY,
      name VARCHAR(10) NOT NULL,
      address VARCHAR(30),
      phone VARCHAR(11),
      email VARCHAR(15),
      notes VARCHAR(50)
      );'
    end

    def index_to_id(index)
      all[index][:id]
    end

    def query_results_to_hash_array(sql)
      contacts = []
      db.query sql do |rows|
        rows.each_hash { |contact| contacts << contact.transform_keys(&:to_sym) }
      end
      contacts
    end

    attr_reader :db
  end
end
