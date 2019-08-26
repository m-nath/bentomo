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
    Konbini.create!(results_hash)
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

huishu = User.create!(
  email: "huishu@gmail.com",
  password: "123123",
  first_name: "Huishu",
  last_name: "Jia",
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/huishu_fdebjg.jpg"
)

# avatar =
#   ["https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw7_v3hxdi.jpg",
#    "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw8_db3gqr.jpg",
#    "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw9_sgyhyr.jpg",
#    "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw2_hynsuc.jpg",
#    "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw3_mj1vpe.jpg",
#    "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw6_dfhsv3.webp",
#    "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw1_qyo2vh.jpg",
#    "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw4_unvhly.jpg"]

#   puts "uploading photos"

# -------------------------------------------------------------------------

puts 'Creating housewife no.1 and its kitchen, plan, dishes'

hw_1= User.create!(
  email:'hw1@gmail.com',
  first_name: 'Tomo',
  last_name: 'Mama',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566801957/Screen_Shot_2019-08-26_at_15.40.15_td9zra.png'
)

konbini_1 = Konbini.find_by(mapbox_id: "e7b032ed39c419052f22a37fd9b17f647e146f37")

kitchen_1 = Kitchen.create!(
  name: 'Tomo Mama`s kitchen',
  description: 'Healthy homemade food full of nutrition',
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802345/Screen_Shot_2019-08-26_at_15.51.21_rngzbg.png",
  user: hw_1,
  tag_list: ['keto', 'low carb', 'japanese', 'healthy', 'nutritious'],
  konbini_id: konbini_1.id
)

plan_1 = Plan.create!(
  name: 'Healthy bento plan',
  description: '5 Days healthy lunch bento plan: each meal has high protein content and low carbohydrates.'+'\n'+
  'Recommended for people who are trying to limit carbohydrates intake',
  price: 600,
  kitchen: kitchen_1,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797616/09d90a044e3723351bcb1177813730bd7070814c_curxdw.jpg",
  tag_list: ['low carb', 'keto', 'high protein'],
)

Dish.create!(
      name: 'Salmon bento with cauliflower rice',
      kitchen: kitchen_1,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797877/eb9fe25a56fa5bd32e6ea839e16763123aa9659c_k0zpd6.jpg"
    )
Dish.create!(
      name: '3 colour bento',
      kitchen: kitchen_1,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566799087/348d2f8f6f8ca22173be85bac1ad209ce9bdde64_y7iqns.jpg"
    )

Dish.create!(
      name: 'Oden bento',
      kitchen: kitchen_1,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566798597/649b65f93bc49abd9b27d5621c68e001ec61deb4_ficikm.jpg"
    )

Dish.create!(
      name: 'Juicy chicken bento',
      kitchen: kitchen_1,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797740/b497627bb27affe0e4bf43703808ee727010a993_s7y0bv.jpg"
    )
Dish.create!(
      name: 'Tara white fish bento',
      kitchen: kitchen_1,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797840/8e8c2686f374e20f756282d20e7d3487c728c163_uytllu.jpg"
    )

kitchen_1.dishes.take(5).each do |dish|
    DishPlan.create!(
      dish: dish,
      plan: plan_1,
    )
  end

# -------------------
# -------------------------------------------------------------------------

puts 'Creating housewife no.2 and its kitchen, plan, dishes'

hw_2= User.create!(
  email:'hw2@gmail.com',
  first_name: 'Yuko',
  last_name: 'Tanaka',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566803594/Screen_Shot_2019-08-26_at_16.12.42_ldzwz0.png'
)

kitchen_2 = Kitchen.create!(
  name: 'Yuko`s kitchen',
  description: 'Healthy homemade food full of nutrition',
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566803551/hw10_dcitx0.jpg",
  user: hw_2,
  tag_list: ['japanese', 'healthy', 'nutritious'],
  konbini_id: Konbini.all.ids.sample
)

plan_2 = Plan.create!(
  name: 'Weekly balance plan',
  description: '5 Days balance lunch bento plan with varieties',
  price: 700,
  kitchen: kitchen_2,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566803219/media_ddu2xi.jpg",
  tag_list: ['japanese', 'healthy', 'nutritious'],
)

Dish.create!(
      name: 'Maguro bento',
      kitchen: kitchen_2,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802230/cg4novwi51skxog6ojno.jpg"
    )
Dish.create!(
      name: 'Tofu bento',
      kitchen: kitchen_2,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802168/urswr8pop0gn6zbtnfnw.jpg"
    )

Dish.create!(
      name: 'Prawn curry',
      kitchen: kitchen_2,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802117/odu3qomow649q4x4xbad.jpg"
    )

Dish.create!(
      name: 'Seafood soup',
      kitchen: kitchen_2,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802114/nr7tcbxuiz6ytupmuiyi.jpg"
    )
Dish.create!(
      name: 'Chesse pasta',
      kitchen: kitchen_2,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802095/ynuqrlvz5jzyjsxt8ks6.jpg"
    )

kitchen_2.dishes.take(5).each do |dish|
    DishPlan.create!(
      dish: dish,
      plan: plan_2,
    )
  end

# -------------------
# only hw, kitchen, plan, changes, -------------------------------------------------------------------------

puts 'Creating housewife no.3 and its kitchen, plan, dishes'

hw_3= User.create!(
  email:'hw3@gmail.com',
  first_name: 'Aya',
  last_name: 'Ishii',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566799929/ktf4rhmszneqxkie9isq.webp'
)

kitchen_3 = Kitchen.create!(
  name: 'Aya kitchen',
  description: 'Healthy homemade food full of nutrition',
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797775/5e603c62ea570fb2852d52e034bc85a539ef12ce_lvl4tx.jpg",
  user: hw_3,
  tag_list: ['japanese', 'high protein', 'nutritious'],
  konbini_id: Konbini.all.ids.sample
)

plan_3 = Plan.create!(
  name: 'Weekly balance plan',
  description: '5 Days balance lunch bento plan with varieties',
  price: 800,
  kitchen: kitchen_3,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566799939/capg70tq2vvv2itcrl4v.jpg",
  tag_list: ['japanese', 'high protein', 'nutritious'],
)

Dish.create!(
      name: 'Maguro bento',
      kitchen: kitchen_3,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802230/cg4novwi51skxog6ojno.jpg"
    )
Dish.create!(
      name: 'Tofu bento',
      kitchen: kitchen_3,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802168/urswr8pop0gn6zbtnfnw.jpg"
    )

Dish.create!(
      name: 'Prawn curry',
      kitchen: kitchen_3,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802117/odu3qomow649q4x4xbad.jpg"
    )

Dish.create!(
      name: 'Seafood soup',
      kitchen: kitchen_3,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802114/nr7tcbxuiz6ytupmuiyi.jpg"
    )
Dish.create!(
      name: 'Chesse pasta',
      kitchen: kitchen_3,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802095/ynuqrlvz5jzyjsxt8ks6.jpg"
    )

kitchen_3.dishes.take(5).each do |dish|
    DishPlan.create!(
      dish: dish,
      plan: plan_3,
    )
  end

# -------------------
puts 'Creating housewife no.4 and its kitchen, plan, dishes'

hw_4= User.create!(
  email:'hw4@gmail.com',
  first_name: 'Sara',
  last_name: 'Nakamura',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566802047/wkxpf0n9yn0s297aajwm.jpg'
)

kitchen_4 = Kitchen.create!(
  name: 'Sara homemade',
  description: 'Healthy homemade food full of nutrition',
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566806151/Mmb5LIozlndS42We9fWsluvEbinl54lxYjVPCaIKQkQhDrdkbs8aY2yPaJij5rsL_tj4bcw.jpg",
  user: hw_4,
  tag_list: ['high protein', 'nutritious'],
  konbini_id: Konbini.all.ids.sample
)

plan_4 = Plan.create!(
  name: 'Protein plan',
  description: '5 Days protein bento plan with varieties',
  price: 800,
  kitchen: kitchen_4,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566799058/aa8fdf9deed8ec996bddbe7ebe7afb0519ede164_hhnlrt.jpg",
  tag_list: ['japanese', 'high protein', 'nutritious'],
)

Dish.create!(
      name: 'Maguro bento',
      kitchen: kitchen_4,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802230/cg4novwi51skxog6ojno.jpg"
    )
Dish.create!(
      name: 'Tofu bento',
      kitchen: kitchen_4,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802168/urswr8pop0gn6zbtnfnw.jpg"
    )

Dish.create!(
      name: 'Prawn curry',
      kitchen: kitchen_4,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802117/odu3qomow649q4x4xbad.jpg"
    )

Dish.create!(
      name: 'Seafood soup',
      kitchen: kitchen_4,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802114/nr7tcbxuiz6ytupmuiyi.jpg"
    )
Dish.create!(
      name: 'Chesse pasta',
      kitchen: kitchen_4,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802095/ynuqrlvz5jzyjsxt8ks6.jpg"
    )

kitchen_4.dishes.take(5).each do |dish|
    DishPlan.create!(
      dish: dish,
      plan: plan_4,
    )
  end

# -------------------
# -------------------
puts 'Creating housewife no.5 and its kitchen, plan, dishes'

hw_5= User.create!(
  email:'hw5@gmail.com',
  first_name: 'Eri',
  last_name: 'Shimada',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566806362/Screen_Shot_2019-08-26_at_16.58.56_udc4go.png'
)

kitchen_5 = Kitchen.create!(
  name: 'Kids Happiness',
  description: 'Specialized in Kids bento',
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566806332/tfEfVe3jp6BUfqALkJWE74jqdIvIRDigFTcz4xNEFqjsNWnoiIGqAnqaRHYRxvRn_gt1pkm.jpg",
  user: hw_5,
  tag_list: ['kids', 'nutritious'],
  konbini_id: Konbini.all.ids.sample
)

plan_5 = Plan.create!(
  name: 'Kids bento plan',
  description: '5 Days nutritious kids bento plan',
  price: 800,
  kitchen: kitchen_5,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566806459/0f49b057_diutoo.jpg",
  tag_list: ['kids', 'nutritious'],
)

Dish.create!(
      name: 'Maguro bento',
      kitchen: kitchen_5,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566806645/924954pb01_44113N_ay8eal.jpg"
    )
Dish.create!(
      name: 'Tofu bento',
      kitchen: kitchen_5,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566806752/0_tivkoi.jpg"
    )

Dish.create!(
      name: 'Prawn curry',
      kitchen: kitchen_5,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566806770/3_vrvtnc.jpg"
    )

Dish.create!(
      name: 'Seafood soup',
      kitchen: kitchen_5,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566806459/0f49b057_diutoo.jpg"
    )
Dish.create!(
      name: 'Chesse pasta',
      kitchen: kitchen_5,
      remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566807039/Qt8GuENs8RMsW2bD_l_gxjkfb.jpg"
    )

kitchen_5.dishes.take(5).each do |dish|
    DishPlan.create!(
      dish: dish,
      plan: plan_5,
    )
  end

# -------------------




# puts "added #{User.count} users."

# tags_array =[
#   ['healthy', 'low carb'],
#   ['gluten free', 'keto'],
#   ['protein'],
#   ['muscle'],
#   ['keto', 'low carb'],
#   ['japanese', 'low carb', 'low calorie'],
#   ['chinese', 'low carb']
# ]

User.all.each do |user|
  rand(1..3).times do
    Location.create!(
      label: ["Home", "Work"].sample,
      address: ["1-3-21, Meguro, Meguro-ku, Tokyo", "3-13-6, Meguro, Meguro-ku, Tokyo", "1-21-20, Higashiyama, Meguro-ku, Tokyo", "‎2 Shimomeguro, Meguro-ku, Tokyo", "1-24-9, Meguro, Meguro-ku, Tokyo", "2 Chome-20-8 Shimomeguro, Meguro City, Tokyo", "2-19-15 Kamimeguro, Meguro-ku, Tokyo", "1-8-1 Shimomeguro, Meguro-ku, Tokyo", "4-1-1 Shimomeguro, Meguro-ku, Tokyo", "2-4-36 Meguro, Meguro-ku, Tokyo"].sample,
      user: user  #real office addres e.g. Google, Amazon, Rakuten, Impacthub
    )
  end
end

# puts 'Destroying 1kitchen-christee`s'


# puts "added #{Kitchen.count} kitchens."
# puts "added #{Location.count} locations."

# Kitchen.all.each do |kitchen|
#   rand(1..2).times do
#     Plan.create!(
#       name: Faker::Restaurant.type + ' plan',
#       price: [500,600, 700, 800, 900, 1000, 1100, 1200, 1300].sample,
#       kitchen: kitchen,
#       remote_photo_url: "https://source.unsplash.com/400x300/?healthy-food" || "https://source.unsplash.com/400x300/?dinner",
#       description: Faker::Restaurant.description[0..100],
#       tag_list: tags_array.sample
#     )
#   end

#   rand(10..15).times do
#     Dish.create!(
#       name: Faker::Food.dish,
#       kitchen: kitchen,
#       remote_photo_url: "https://source.unsplash.com/400x300/?meal"
#     )
#   end
# end

# Plan.all.each do |plan|
#   plan.kitchen.dishes.take(5).each do |dish|
#     DishPlan.create!(
#       dish: dish,
#       plan: plan,
#     )
#   end
# end

User.all.each do |user|
  kitchen = Kitchen.where.not(user: user).sample
  plan = kitchen.plans.sample
  # create order for past
  rand(2..4).times do
    kitchen = Kitchen.where.not(user: user).sample
    plan = kitchen.plans.sample
    Order.create!(
      user: user,
      plan: plan,
      date: "2019-08-15 to 2019-08-20",
      amount: plan.price
    )
  end
end

# puts "added #{Plan.count} Plans."
# puts "added #{Dish.count} dishes."


# end
# ---------------------------
chat_room = ChatRoom.create!(name: "general")

message_1 = Message.create!(
  content: "Hello",
  chat_room: chat_room,
  user: christee
)
message_2 = Message.create!(
  content: "Hey",
  chat_room: chat_room,
  user: nath
)
message_3 = Message.create!(
  content: "Yo",
  chat_room: chat_room,
  user: christee
)


puts "Seed is done!"
