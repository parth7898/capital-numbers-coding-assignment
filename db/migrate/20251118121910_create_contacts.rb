class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email, null: false
      t.references :organization, foreign_key: true
      t.timestamps
    end
     add_index :contacts, :email, unique: true
  end
end
