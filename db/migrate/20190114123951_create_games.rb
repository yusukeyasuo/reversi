class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.references :user, index: true
      t.integer :status, default: 0
      t.boolean :senko, default: 1

      t.timestamps
    end
  end
end
