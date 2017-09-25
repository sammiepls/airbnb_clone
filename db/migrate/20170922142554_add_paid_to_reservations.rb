class AddPaidToReservations < ActiveRecord::Migration[5.0]
  def change
    add_column :reservations, :paid, :boolean, default:false
  end
end
