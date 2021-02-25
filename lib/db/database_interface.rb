# frozen_string_literal: true

module DB
  class DatabaseInterface
    def all
      raise NotImplementedError
    end

    def create(contact)
      raise NotImplementedError
    end

    def count
      raise NotImplementedError
    end

    def database_empty?
      raise NotImplementedError
    end

    def search(term)
      raise NotImplementedError
    end

    def contact_at(index)
      raise NotImplementedError
    end

    def update(index, new_data)
      raise NotImplementedError
    end

    def delete(index)
      raise NotImplementedError
    end
  end
end
