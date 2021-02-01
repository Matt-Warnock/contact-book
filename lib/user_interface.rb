# frozen_string_literal: true

class UserInterface # rubocop:disable Metrics/ClassLength
  def initialize(input, output, validator, messages)
    @input = input
    @output = output
    @validator = validator
    @messages = messages
  end

  def menu_choice
    output.print messages.clear_command, messages.menu_message
    collect_valid_input { |user_input| validator.valid_choice?(user_input, messages.actions_count) }.to_i
  end

  def ask_for_fields
    messages.fields_to_prompts.to_h.each_with_object({}) do |(field, prompt), contact_details|
      output.print prompt
      contact_details[field] = collect_field_value(field)
    end
  end

  def display_contact(contact)
    display_names = messages.fields_to_display_names.to_h
    longest_display_name = display_names.values.max_by(&:length)

    output.print "\n"
    contact.each do |field, value|
      output.puts display_names[field].ljust(longest_display_name.length) + value
    end
  end

  def add_another_contact?
    boolean_choice?(messages.another_contact_prompt)
  end

  def display_no_contacts_message
    output.puts messages.no_contacts_message
  end

  def display_letter_header(letter)
    output.print %(
------------------------------
              #{letter.upcase}
------------------------------
)
  end

  def continue
    output.print messages.continue_message
    input.getch
  end

  def search_term
    output.print messages.search_message
    collect_valid_input { |user_input| validator.valid_string?(user_input) }
  end

  def search_again?
    boolean_choice?(messages.another_search_prompt)
  end

  def choose_contact(contacts)
    display_all_with_index(contacts)
    ask_for_index(contacts.length).to_i
  end

  def edit_field
    output.print messages.field_choice_prompt

    field = collect_field_name
    output.print messages.fields_to_prompts[field]
    value = collect_field_value(field)
    { field => value }
  end

  def update_another_field?
    boolean_choice?(messages.another_edit_prompt)
  end

  def update_another_contact?
    boolean_choice?(messages.another_update_prompt)
  end

  def delete?(contact)
    boolean_choice?(messages.delete_contact_prompt) { display_contact(contact) }
  end

  def display_deletion_message
    output.print messages.contact_deleted_message
  end

  def delete_another_contact?
    boolean_choice?(messages.another_delete_prompt)
  end

  private

  def ask_for_index(array_length)
    output.print messages.contact_index_prompt
    collect_valid_input { |user_input| validator.valid_index?(user_input, array_length) }
  end

  def display_all_with_index(contacts)
    contacts.each_with_index do |contact, index|
      output.print "[#{index}]"
      display_contact(contact)
    end
  end

  def collect_field_name
    field_name = collect_valid_input do |user_input|
      validator.valid_field_name?(user_input, messages.fields_to_display_names.to_h)
    end
    convert_name_to_key(field_name)
  end

  def convert_name_to_key(field_name)
    messages.fields_to_display_names.to_h.select { |_, name| name.match?(/#{field_name}/i) }.keys.first
  end

  def collect_field_value(field)
    collect_valid_input { |user_input| validator.valid_field_value?(field, user_input) }
  end

  def boolean_choice?(prompt)
    output.print prompt
    yield if block_given?

    collect_valid_input do |user_input|
      validator.valid_yes_no_answer?(user_input, messages.valid_yes_no_reply)
    end.downcase == messages.yes_reply
  end

  def collect_valid_input
    loop do
      user_input = input.gets.chomp
      break user_input if yield user_input

      output.print messages.error_message
    end
  end

  attr_reader :input, :output, :validator, :messages
end
