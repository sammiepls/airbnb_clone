class Listing < ApplicationRecord
  mount_uploaders :photos, PhotoUploader
  # Associations
  belongs_to :user
  has_many :reservations, dependent: :destroy
  # Taggable
  acts_as_taggable_on :tags
  # Search Scope
  scope :verification, -> (verification) { where verification: true }
  scope :guest_pax_has, -> (guest_pax) { where guest_pax: guest_pax }
  scope :country_has, -> (country) { where country: country }
  scope :name_has, -> (name) { where("name like ?", "%#{name}%")}
  scope :description_has, -> (description) {where("description like ?", "%#{description}%")}
  scope :city_has, -> (city) {where("city like ?", "%#{city}%")}
  scope :state_has, -> (state) {where("state like ?", "%#{state}%")}
  # scope :price -> (low, high) { where("price < ? AND price > ?", high, low)}

  # Validation
  NON_VALIDATABLE_ATTRS = ["id", "created_at", "updated_at", "user", "photos", "verification"]
  #^or any other attribute that does not need validation
  VALIDATABLE_ATTRS = Listing.attribute_names.reject{|attr| NON_VALIDATABLE_ATTRS.include?(attr)}
  validates_presence_of VALIDATABLE_ATTRS
  #validating the presence of everything else
  validates :price_per_night, format: { with: /\A\d+(?:\.\d{0,2})?\z/, message:"has other characters besides numbers and decimal points." }, numericality: true
  validates :zipcode,:guest_pax, :bedroom_count, :bathroom_count, numericality: true
  validate :check_country

  def self.search(params)
    @listings = Listing.verification
    params.each do |key, value|
      unless value.blank?
        @listings = @listings.verification.send(key.to_s + "_has",value)
      end
    end
    @listings
    #
    # @listings = @listings.guest_pax(params[:guest_pax]) unless params[:guest_pax].blank?
    # @listings = @listings.name(params[:name]) unless params[:name].blank?
    # @listings = @listings.description(params[:description]) unless params[:description].blank?
    # @listings = @listings.city(params[:city]) unless params[:city].blank?
    # @listings = @listings.state(params[:state]) unless params[:state].blank?
    # @listings = @listings.country(params[:country]) unless params[:country].blank?
  end
  # def self.search(term)
  #   if term
  #     if self.country_code(term).nil?
  #       where('name ILIKE ? OR description ILIKE ? OR city ILIKE ? OR state ILIKE ?', "%#{term}%", "%#{term}%", "%#{term}%", "%#{term}%").order('id DESC')
  #     else
  #       where('name ILIKE ? OR description ILIKE ? OR country ILIKE ? OR city ILIKE ? OR state ILIKE ?', "%#{term}%", "%#{term}%", "%#{self.country_code(term)}%", "%#{term}%", "%#{term}%").order('id DESC')
  #     end
  #   else
  #     order('id DESC')
  #   end
  # end

  def country_name
    country = ISO3166::Country[self.country]
    country.translations[I18n.locale.to_s] || country.name
  end

  def self.country_code(term)
    result = ISO3166::Country.translations.find { |key, value| term.include? value }
    if result.nil?
      nil
    else
      result[0]
    end
  end

  def check_country
    if !ISO3166::Country.translations.include? country
      errors.add(:country, "is not a valid country")
    end
  end
  private
  def filtering_params(params)
    params.slice(:verification, :country, :city, :state, :name, :description)
  end

  def filter(filtering_params)
      results = self.where(nil) # create an anonymous scope
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
  end

end
