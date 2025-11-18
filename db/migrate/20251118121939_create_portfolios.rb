class CreatePortfolios < ActiveRecord::Migration[5.2]
  def change
    create_table :portfolios do |t|
      t.references :contact, foreign_key: true
      t.string :name
      t.decimal :balance, precision: 15, scale: 2
      t.decimal :performance, precision: 8, scale: 2
      t.timestamps
    end
  end
end
