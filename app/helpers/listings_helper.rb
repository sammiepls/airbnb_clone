module ListingsHelper
  def country_name
    ISO3166::Country.translations.find {|k,v| @listing.country.include? k}[1]
  end
end
