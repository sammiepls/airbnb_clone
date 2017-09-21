class Reservation < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :listing
  # Validation
  validates :guest_pax,:check_in, :check_out, presence: true
  validates :guest_pax, numericality: true
  # validates_each :check_in do |record, attr, value|
  #     record.errors.add(attr, 'Invalid date') if value < Time.now.to_date
  #   end
  validate :check_max_guests
  validate :check_overlapping_dates


  def check_max_guests
    max_guests = listing.guest_pax
    if guest_pax != nil
      return if guest_pax <= max_guests
      errors.add(:guest_pax, {message: "There are too many guests"})
    else
      errors.add(:guest_pax,{message: "Please input number of guests"})
    end
  end

  def check_overlapping_dates
    if check_in != nil && check_out != nil
      Reservation.where(listing_id:listing.id).each do |reservation|
        if overlap?(self,reservation)
          return errors.add(:overlapping_dates, message: "These dates are not available for booking")
        end
      end
    else
      return errors.add(:overlapping_dates, "Please input a check-in and check-out date")
    end
  end

  def overlap?(x,y)
    (x.check_in - y.check_out) * (y.check_in - x.check_out) > 0
  end

  def total_price
    price = listing.price_per_night
    num_dates = (check_in..check_out).to_a.length
    return price * num_dates
  end
end
