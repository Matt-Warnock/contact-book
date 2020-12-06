# frozen_string_literal: true

module Constants
  ACTIONS_COUNT = 5
  ANOTHER_CONTACT_PROMPT = 'Add another contact? (y/n): '
  ANOTHER_EDIT_PROMPT = 'Update another detail? (y/n): '
  ANOTHER_SEARCH_PROMPT = 'Search again? (y/n): '
  ANOTHER_UPDATE_PROMPT = 'Update another contact? (y/n): '
  CLEAR_COMMAND = "\033[H\033[2J"
  CONTACT_INDEX_PROMPT = 'Enter contact index: '
  CONTINUE_MESSAGE = 'Press any key to continue '
  EXIT_CHOICE = 5
  FIELD_CHOICE_PROMPT = 'Which detail of the contact would you like to edit? '
  ERROR_MESSAGE = 'Wrong input. Please try again: '
  NO_CONTACTS_MESSAGE = 'No contacts were found.'
  SEARCH_MESSAGE = 'Type search term: '
  MENU_MESSAGE = %{
    ---------------------

        CONTACT BOOK

    ---------------------


  1) List contacts
  2) Add contact
  3) Search contact
  4) Update contact
  5) Exit the program

  Choose a menu option: }

  FIELDS_TO_DISPLAY_NAMES = {
    name: 'Name: ',
    address: 'Address: ',
    phone: 'Phone: ',
    email: 'Email: ',
    notes: 'Notes: '
  }.freeze

  FIELDS_TO_PROMPTS = {
    name: 'Contact name: ',
    address: 'Contact address: ',
    phone: 'Contact phone: ',
    email: 'Contact email: ',
    notes: 'Contact notes: '
  }.freeze

  VALID_YES_NO_REPLY = /^[yn]$/i.freeze

  YES_REPLY = 'y'
end
