class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :user_id, null:false
      t.string :title, null:false
      t.text :content, null:false
      t.string :area, null:false
      t.string :category, null:false

      t.timestamps
    end
  end
end
