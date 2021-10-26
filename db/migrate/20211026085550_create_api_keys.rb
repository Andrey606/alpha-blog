class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys do |t|
      t.integer :user_id
      t.string :api_key
      t.timestamps
    end
  end
end
