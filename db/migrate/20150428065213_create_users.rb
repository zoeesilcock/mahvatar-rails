class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :identifier
      t.string :name
      t.string :head

      t.timestamps null: false
    end
  end
end
