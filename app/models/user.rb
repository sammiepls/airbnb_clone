class User < ApplicationRecord
  include Clearance::User
  # Validation
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :first_name,:last_name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum:7, too_short: "Password must be at least 7 characters long" }

  def capitalize
    self.first_name = self.first_name.capitalize
    self.last_name = self.last_name.capitalize
    self.email = self.email.downcase
  end

  def full_name
    self.first_name + " " + self.last_name
  end

end
