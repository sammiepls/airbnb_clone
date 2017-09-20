class Reservation < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :listing
  # Validation
  validates :guest_pax,:check_in, :check_out, presence: true
  validates :guest_pax, numericality: true
  validates_each :check_in do |record, attr, value|
      record.errors.add(attr, 'Invalid date') if value < Time.now.to_date
    end
end
