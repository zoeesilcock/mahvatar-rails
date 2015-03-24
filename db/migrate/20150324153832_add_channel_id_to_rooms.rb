class AddChannelIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :channel_id, :string
  end
end
