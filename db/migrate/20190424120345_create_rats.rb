class CreateRats < ActiveRecord::Migration[6.0]
  def up
    create_table :rats do |t|
      t.string :name
      t.integer :speed
      t.timestamps
    end
  end

  def down
    drop_table :rats
  end
end
