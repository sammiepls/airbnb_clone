class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.string :name
      t.string :description
      t.string :address
      t.integer :guest_pax
      t.integer :bedroom_count
      t.integer :bathroom_count
      t.decimal :price_per_night, precision:8, scale:2
      t.belongs_to :user, index:true, foreign_key:true
      t.timestamps
    end
  end
end
