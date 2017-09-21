class Listing < ApplicationRecord
  mount_uploaders :photos, PhotoUploader
  # Associations
  belongs_to :user
  has_many :reservations, dependent: :destroy
  # Taggable
  acts_as_taggable_on :tags

  # Validation
  NON_VALIDATABLE_ATTRS = ["id", "created_at", "updated_at", "user", "photos", "verification"]
  #^or any other attribute that does not need validation
  VALIDATABLE_ATTRS = Listing.attribute_names.reject{|attr| NON_VALIDATABLE_ATTRS.include?(attr)}
  validates_presence_of VALIDATABLE_ATTRS
  #validating the presence of everything else
  validates :price_per_night, format: { with: /\A\d+(?:\.\d{0,2})?\z/, message:"has other characters besides numbers and decimal points." }, numericality: true
  validates :guest_pax, :bedroom_count, :bathroom_count, numericality: true

  def self.search(term)
    if term
      where('name ILIKE ? OR description ILIKE ?', "%#{term}%", "%#{term}%").order('id DESC')
    else
      order('id DESC')
    end
  end

end
