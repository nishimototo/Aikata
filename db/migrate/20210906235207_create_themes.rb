class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.integer :user_id, null:false
      t.string :image_id
      t.text :content, null:false

      t.timestamps
    end
  end
end
