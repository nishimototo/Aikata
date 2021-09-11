class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.string :area
      t.string :category

      t.timestamps
    end
  end
end
