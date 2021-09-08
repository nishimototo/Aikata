class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.integer :user_id
      t.integer :answer_id
      t.float :rate

      t.timestamps
    end
  end
end
