class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.references :user, index: true
      t.integer :status
      t.boolean :senko

      t.timestamps
    end
  end
end