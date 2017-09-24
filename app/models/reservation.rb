class Reservation < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :listing
  # Validation
  validates :guest_pax,:check_in, :check_out, presence: true
  validates :guest_pax, numericality: true
  validate :check_max_guests
  validate :check_overlapping_dates
  validate :check_date_eligibility
  validate :check_out_after_check_in

  def check_date_eligibility
    if check_in != nil
       if check_in < Date.today
         errors.add(:check_in, "date can't be in the past")
       end
    elsif check_out != nil
      if check_out < Date.today
        errors.add(:check_out, "date can't be in the past")
      end
    end
  end

  def check_out_after_check_in
    if check_out != nil && check_in != nil
      if check_out < check_in
        errors.add(:check_out, "date can't be before check in date")
      end
    end
  end

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
    num_dates = (check_in..check_out).to_a.length - 1
    return price * num_dates
  end
end
