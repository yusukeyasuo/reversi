class CreateGameDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :game_details do |t|
      t.references :game, index: true
      t.text :formation

      t.timestamps
    end
  end
end
