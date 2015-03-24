class AddChannelAndActiveToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :channel, :string
    add_column :rooms, :active, :boolean
  end
end
