class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.belongs_to :user, index:true, foreign_key:true
      t.belongs_to :listing, index:true, foreign_key:true
      t.integer :guest_pax
      t.date :check_in
      t.date :check_out
      t.timestamps
    end
  end
end
