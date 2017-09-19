# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seed Users
user = {}
user['password'] = 'abc1234'

ActiveRecord::Base.transaction do
  20.times do
    user['first_name'] = Faker::Name.first_name
    user['last_name'] = Faker::Name.last_name
    user['email'] = Faker::Internet.email

    User.create(user)
  end
end

# Seed Listings
listing = {}
uids = []
User.all.each { |u| uids << u.id }

ActiveRecord::Base.transaction do
  40.times do
    listing['name'] = Faker::App.name

    listing['bathroom_count'] = rand(0..5)
    listing['bedroom_count'] = rand(1..6)
    listing['guest_pax'] = rand(1..10)
    listing['address'] = Faker::Address.street_address
    listing['description'] = Faker::Hipster.sentence
    listing['price_per_night'] = rand(80..500)
    listing['user_id'] = uids.sample

    Listing.create(listing)
  end
end
