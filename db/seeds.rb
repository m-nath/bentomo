# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "seed starts"
puts 'destroy previous seeds'

Order.destroy_all if Rails.env.development?
DishPlan.destroy_all if Rails.env.development?
Kitchen.destroy_all if Rails.env.development?
Plan.destroy_all if Rails.env.development?
Location.destroy_all if Rails.env.development?
User.destroy_all if Rails.env.development?
Dish.destroy_all if Rails.env.development?

require 'net/http'
require 'uri'

puts 'creating konbini'

areas = ["Meguro"]
areas.each do |area|
  uri = URI.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?query=convenience+stores+in+#{area}&key=#{ENV['GOOGLEMAP_API_KEY']}")
  response = Net::HTTP.get_response(uri)
  list = JSON.parse(response.body)
  list["results"].each do |result|
    results_hash = {}
    results_hash[:mapbox_id] = result["id"]
    results_hash[:name] = result["name"]
    results_hash[:address] = result["formatted_address"]
    results_hash[:latitude] = result["geometry"]["location"]["lat"]
    results_hash[:longitude] = result["geometry"]["location"]["lng"]
    Konbini.create(results_hash)
  end
end


puts "creating users with photos"

nath = User.create!(
  email: "nath@gmail.com",
  password: "123123",
  first_name: "Nath",
  last_name: "M",
  admin: false,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268733/nath_q0kaa1.png",
  preference: 'no raw tomato, no raw onion'
)

christee = User.create!(
  email: "christee.song@gmail.com",
  password: "123123",
  first_name: "Christee",
  last_name: "Song",
  admin: false,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268919/51040522_mxitwx.jpg",
  preference: '(1) Strict low carb diet; (2) No raw onion; '
)

shohei = User.create!(
  email: "shohei@gmail.com",
  password: "123123",
  first_name: "Shohei",
  last_name: "Okubo",
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/shohei_rttagy.jpg"
)

doug = User.create!(
  email: "doug@gmail.com",
  password: "123123",
  first_name: "Doug",
  last_name: "Berkley",
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/doug_hwhpw6.png"
)

sylvain = User.create!(
  email: "sylvain@gmail.com",
  password: "123123",
  first_name: "Sylvain",
  last_name: "Pierre",
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/sylvain_q1ry1x.png"
)

huishu = User.create!(
  email: "huishu@gmail.com",
  password: "123123",
  first_name: "Huishu",
  last_name: "Jia",
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/huishu_fdebjg.jpg"
)

avatar =
  ["https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw7_v3hxdi.jpg",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw8_db3gqr.jpg",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw9_sgyhyr.jpg",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw2_hynsuc.jpg",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw3_mj1vpe.jpg",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw6_dfhsv3.webp",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw1_qyo2vh.jpg",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw4_unvhly.jpg"]

  puts "uploading photos"

demo_hw = User.create!(
  email:'hw@gmail.com',
  first_name: 'Tomo',
  last_name: 'Mama',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw5_l5gr7w.jpg'
)

demo_kitchen = Kitchen.create!(
  name: 'Tomo Mama`s kitchen',
  description: 'Healthy homemade food full of nutrition',
  remote_photo_url: "https://source.unsplash.com/400x300/?healthy-food",
  user: demo_hw,
  tag_list: ['keto', 'low carb', 'japanese', 'healthy', 'nutritious'],
  konbini_id: Konbini.first.id
)

3.times do #change to more times later
  User.create!(email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: "123123", remote_photo_url: avatar.sample)
end


puts "added #{User.count} users."

tags_array =[
  ['healthy', 'low carb'],
  ['gluten free', 'keto'],
  ['protein'],
  ['muscle'],
  ['keto', 'low carb'],
  ['japanese', 'low carb', 'low calorie'],
  ['chinese', 'low carb']
]

User.all.each do |user|
  e = Kitchen.create!(
    name: Faker::Restaurant.name,
    description: Faker::Restaurant.description[0..100],
    remote_photo_url: "https://source.unsplash.com/400x300/?lunch",
    user: user,
    tag_list: tags_array.sample,
    konbini_id: Konbini.all.ids.sample
  )
  puts "created #{e.name}"

  rand(1..2).times do
    Location.create!(
      label: ["home", "work"].sample,
      address: ["Lawson Shibuya", "Family-mart Shinjuku", "Seven-eleven Meguro"].sample,
      user: user  #real office addres e.g. Google, Amazon, Rakuten, Impacthub
    )
  end
end

puts 'Destroying 1kitchen-christee`s'

Kitchen.find_by(user_id:User.second.id).destroy! #christee
Kitchen.find_by(user_id:User.fourth.id).destroy!
Kitchen.find_by(user_id:User.fifth.id).destroy!

doug_K = Kitchen.create!(
    name: 'Dougs Kitchen',
    description: 'Good American food here!',
    remote_photo_url: "https://scontent-nrt1-1.xx.fbcdn.net/v/t1.0-9/49206011_10161288945565300_3488969622948937728_o.jpg?_nc_cat=110&_nc_oc=AQnCYIzOQR9tLF4KmeXAVpJMLQ1y8ZiGTsr3Ie187N68Qd61Fre80TBGpH2XFtCE6rs&_nc_ht=scontent-nrt1-1.xx&oh=58d0f2fe68f652a4c6901acab59aae0c&oe=5DDE5A42",
    user: doug,
    # tag_list: ['low carb', 'keto', 'american'],
    konbini_id: Konbini.second.id,
  )

sylvain_k = Kitchen.create!(
    name: 'Sylvains Kitchen',
    description: 'Awesome and tasty French food, sometimes Vietnanese food',
    remote_photo_url: "https://scontent-nrt1-1.xx.fbcdn.net/v/t1.0-9/48406957_10161288919900300_887751778529968128_o.jpg?_nc_cat=101&_nc_oc=AQk945oA-48c8gw6ONPS8wIM4f0wM4p_kAcCWxxSDRNPKwgVvWn94-yNFzrPdjZPAw8&_nc_ht=scontent-nrt1-1.xx&oh=9ec03ecf17ddbac6fba8e87ff67c0960&oe=5E07DFE0",
    user: sylvain,
    # tag_list: ['low carb', 'keto', 'French'],
    konbini_id: Konbini.third.id,
  )

puts "added #{Kitchen.count} kitchens."
puts "added #{Location.count} locations."


american_plan = Plan.create!(
      name: 'American plan',
      price: 8000,
      kitchen: doug_K,
      remote_photo_url: "https://source.unsplash.com/400x300/?healthy-food" || "https://source.unsplash.com/400x300/?dinner",
      description: 'A lot of curry, healthy diet pizzas for dirty diet',
      tag_list: ['low carb', 'keto', 'american'],
    )

bikini_plan = Plan.create!(
      name: 'Summer Bikini Plan',
      price: 8000,
      kitchen: doug_K,
      remote_photo_url: "https://scontent-nrt1-1.xx.fbcdn.net/v/t1.0-9/48406957_10161288919900300_887751778529968128_o.jpg?_nc_cat=101&_nc_oc=AQk945oA-48c8gw6ONPS8wIM4f0wM4p_kAcCWxxSDRNPKwgVvWn94-yNFzrPdjZPAw8&_nc_ht=scontent-nrt1-1.xx&oh=9ec03ecf17ddbac6fba8e87ff67c0960&oe=5E07DFE0",
      description: 'A lot of curry, healthy diet pizzas for dirty diet',
      tag_list: ['low carb', 'keto', 'French'],
    )

Kitchen.all.each do |kitchen|
  rand(1..2).times do
    Plan.create!(
      name: Faker::Restaurant.type + ' plan',
      price: [2000, 3000, 4000, 5000, 2500, 3500, 4500, 2300, 2800, 3800, 3200, 4200, 4800].sample,
      kitchen: kitchen,
      remote_photo_url: "https://source.unsplash.com/400x300/?healthy-food" || "https://source.unsplash.com/400x300/?dinner",
      description: Faker::Restaurant.description[0..100],
      tag_list: tags_array.sample
    )
  end

  rand(15).times do
    Dish.create!(
      name: Faker::Food.dish,
      kitchen: kitchen,
      remote_photo_url: "https://source.unsplash.com/400x300/?meal"
    )
  end
end

Plan.all.each do |plan|
  plan.kitchen.dishes.take(5).each do |dish|
    DishPlan.create!(
      dish: dish,
      plan: plan
    )
  end
end

User.all.each do |user|
  # create order for future
  kitchen = Kitchen.where.not(user: user).sample
  plan = kitchen.plans.sample
  Order.create!(
    user: user,
    plan: plan,
    date: Faker::Time.between_dates(from: Date.today, to: Date.today + 7, period: :morning, format: :short),
    amount: plan.price,

  )
  # create order for past
  rand(2..4).times do
    kitchen = Kitchen.where.not(user: user).sample
    plan = kitchen.plans.sample
    Order.create!(
      user: user,
      plan: plan,
      date: Faker::Time.between_dates(from: Date.today - 60, to: Date.today - 7, period: :morning, format: :short),
      amount: plan.price,
    )
  end
end

puts "added #{Plan.count} Plans."
puts "added #{Dish.count} dishes."

puts 'destroy Christees order'
User.second.orders.destroy
puts 'create christee`s order'
rand(2..4).times do
  kitchen = Kitchen.where.not(user: christee).sample
  plan = kitchen.plans.sample
  Order.create!(
    user: christee,
    plan: plan,
    date: Faker::Time.between_dates(from: Date.today - 60, to: Date.today - 7, period: :morning, format: :short),
    amount: plan.price,
  )
end



puts "Seed is done!"
