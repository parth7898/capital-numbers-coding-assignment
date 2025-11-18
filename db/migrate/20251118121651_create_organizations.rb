class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email, null: false
      t.timestamps
    end
    add_index :organizations, :email, unique: true
  end
end
