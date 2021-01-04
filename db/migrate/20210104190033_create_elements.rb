class CreateElements < ActiveRecord::Migration[5.2]
  def change
    create_table :elements do |t|
      t.string :name
      t.string :skill_1
      t.string :skill_2
      t.string :skill_3
      t.string :skill_4
    end
  end
end
