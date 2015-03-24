require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { build :room }

  it 'requires a title' do
    room.title = nil

    expect(room).not_to be_valid
  end

  it 'requires a unique title' do
    first_room = create :room

    expect(room).not_to be_valid
  end
end
