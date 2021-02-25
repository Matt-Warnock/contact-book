# frozen_string_literal: true

require 'actions/null_action'

RSpec.describe Actions::NullAction do
  it 'returns nil' do
    null_action = described_class.new

    expect(null_action.run).to be_nil
  end
end
