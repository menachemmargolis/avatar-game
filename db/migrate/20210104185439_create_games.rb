class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
     t.integer :user_id
     t.integer :user2_id
     t.integer :character_id
     t.integer :character_id2
     t.string :result
     
    end
  end
end
