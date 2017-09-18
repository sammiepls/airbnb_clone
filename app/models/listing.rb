class Listing < ApplicationRecord
  # Associations
  belongs_to :user
  # Validation
  NON_VALIDATABLE_ATTRS = ["id", "created_at", "updated_at", "user"]
  #^or any other attribute that does not need validation
  VALIDATABLE_ATTRS = Listing.attribute_names.reject{|attr| NON_VALIDATABLE_ATTRS.include?(attr)}
  validates_presence_of VALIDATABLE_ATTRS
  #validating the presence of everything else
  validates :price_per_night, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: true

  # def self.search(term)
  #   if term
  #     where("name ILIKE ?, #{term} OR description ILIKE ?, #{term} ")
  #   else
  #     all
  #   end
  # end

  def self.search(term)
    if term
      where('name ILIKE ? OR description ILIKE ?', "%#{term}%", "%#{term}%").order('id DESC')
    else
      order('id DESC')
    end
  end

end
