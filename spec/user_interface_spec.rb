# frozen_string_literal: true

require 'user_interface'

RSpec.describe UserInterface do
  it 'prints menu of options for user to choose' do
    output = StringIO.new
    ui = described_class.new(nil, output)

    ui.run

    expect(output.string).to eq(described_class::MENU_MESSAGE)
  end
end
