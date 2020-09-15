# frozen_string_literal: true

require 'controler'
require 'user_interface'

RSpec.describe Controler do
  it 'tells the user interface to print the menu' do
    input = StringIO.new('1')
    output = StringIO.new
    ui = UserInterface.new(input, output)
    ctrl = Controler.new(ui)

    ctrl.start

    expect(output.string).to include('CONTACT BOOK')
  end
end
