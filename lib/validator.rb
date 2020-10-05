# frozen_string_literal: true

class Validator
  def valid_choice?(option)
    option.match?(/^[1-2]$/)
  end
end
