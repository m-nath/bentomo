# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "seed starts"
puts 'destroy previous seeds'

# Order.destroy_all if Rails.env.development?
# DishPlan.destroy_all if Rails.env.development?
# Kitchen.destroy_all if Rails.env.development?
# Konbini.destroy_all if Rails.env.development?
# Plan.destroy_all if Rails.env.development?
# Location.destroy_all if Rails.env.development?
# User.destroy_all if Rails.env.development?
# Dish.destroy_all if Rails.env.development?

Message.destroy_all
ChatRoom.destroy_all
Order.destroy_all
DishPlan.destroy_all
Kitchen.destroy_all
Konbini.destroy_all
Plan.destroy_all
Location.destroy_all
User.destroy_all
Dish.destroy_all

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
  preference: '(1) No sugar; (2) Milk allergy; '
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

doug = User.create!(
  email: "doug@gmail.com",
  password: "123123",
  first_name: "Doug",
  last_name: "Berkley",
  remote_photo_url: "https://scontent.fkix2-1.fna.fbcdn.net/v/t31.0-8/1495219_10101955351342190_1468891878_o.jpg?_nc_cat=106&_nc_oc=AQnAb76Yhxp74tsJE4u9B-AZx3Zy71vGuIeCLMTK6dyBR5b6bXL4M8Pj59Zvn8Vk3Uw&_nc_ht=scontent.fkix2-1.fna&oh=d6db9d3f172948c1fe478ca78bf18086&oe=5DCC4E95"
)

sylvain = User.create!(
  email: "sylvain@gmail.com",
  password: "123123",
  first_name: "Sylvain",
  last_name: "Pierre",
  remote_photo_url: "https://scontent.fkix2-2.fna.fbcdn.net/v/t1.0-9/10394021_10155168033840300_2776513019293723727_n.jpg?_nc_cat=108&_nc_oc=AQlBKh4gNUO-AgZAGpKQIH0xhhqJcZz4RAmURU6qfIrZx1c_B8eCJOuo0FJ0qc7LMt4&_nc_ht=scontent.fkix2-2.fna&oh=a1ea7baef47e31908113bdb8a19b3435&oe=5E07AE49"
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
  first_name: 'Grandma',
  last_name: 'Mama',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566956558/Screen_Shot_2019-08-28_at_10.41.46_bhvycz.png'
)



kitchen_1 = Kitchen.create!(
  name: 'Wafu kitchen',
  description: 'Healthy homemade food full of nutrition. Especially recommended for people who are trying to limit carbohydrates intake',
  remote_photo_url: "https://res.cloudinary.com/duj5vczom/image/upload/v1567134161/pc_39_m8tf2a.png",
  user: hw_1,
  tag_list: ['low carb', 'japanese', 'healthy', 'nutritious'],
  konbini_id: Konbini.all.ids.sample,
)

plan_1 = Plan.create!(
  name: 'Healthy bento plan',
  description: 'weekday healthy lunch bento plan: each meal has high protein content and low carbohydrates.',
  price: 600,
  kitchen: kitchen_1,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797616/09d90a044e3723351bcb1177813730bd7070814c_curxdw.jpg",
  tag_list: ['low carb', 'keto', 'high protein']
)

Dish.create!(
  name: 'Salmon bento with cauliflower rice',
  kitchen: kitchen_1,
  calories: 798,
  fat: 98,
  protein: 78,
  carbs: 20,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797877/eb9fe25a56fa5bd32e6ea839e16763123aa9659c_k0zpd6.jpg"
)
Dish.create!(
  name: '3 colour bento',
  kitchen: kitchen_1,
  calories: 676,
  fat: 78,
  protein: 83,
  carbs: 30,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566799087/348d2f8f6f8ca22173be85bac1ad209ce9bdde64_y7iqns.jpg"
)

Dish.create!(
  name: 'Oden bento',
  kitchen: kitchen_1,
  calories: 523,
  fat: 59,
  protein: 78,
  carbs: 28,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566798597/649b65f93bc49abd9b27d5621c68e001ec61deb4_ficikm.jpg"
)

Dish.create!(
  name: 'Juicy chicken bento',
  kitchen: kitchen_1,
  calories: 676,
  fat: 75,
  protein: 90,
  carbs: 20,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797740/b497627bb27affe0e4bf43703808ee727010a993_s7y0bv.jpg"
)
Dish.create!(
  name: 'Tara white fish bento',
  kitchen: kitchen_1,
  calories: 562,
  fat: 72,
  protein: 78,
  carbs: 20,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566797840/8e8c2686f374e20f756282d20e7d3487c728c163_uytllu.jpg"
)

kitchen_1.dishes.take(5).each do |dish|
  DishPlan.create!(
    dish: dish,
    plan: plan_1
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
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566959416/Screen_Shot_2019-08-28_at_11.29.48_pgatn7.png'
)

konbini_2 = Konbini.find_by(mapbox_id: "e7b032ed39c419052f22a37fd9b17f647e146f37")

kitchen_2 = Kitchen.create!(
  name: 'Yuko`s kitchen',
  description: 'Healthy homemade food full of nutrition',
  remote_photo_url: "https://www.besthealthmag.ca/wp-content/uploads/sites/16/2017/10/healthy-cooking-classes-in-Canada.jpg",
  user: hw_2,
  tag_list: ['japanese', 'healthy', 'nutritious','diet'],
  konbini_id: konbini_2.id,
  video: 'https://youtu.be/6RuShc7NSV4?t=20'
)

plan_2 = Plan.create!(
  name: 'Nutrition protein plan',
  description: 'weekday balance lunch bento plan with varieties',
  price: 700,
  kitchen: kitchen_2,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566803219/media_ddu2xi.jpg",
  tag_list: ['japanese', 'healthy', 'nutritious','diet']
)

Dish.create!(
  name: 'Maguro bento',
  kitchen: kitchen_2,
  calories: 698,
  fat: 98,
  protein: 78,
  carbs: 20,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566995150/pabsmyql8fph2vzetzt8.jpg"
)
Dish.create!(
  name: 'Tofu bento',
  kitchen: kitchen_2,
  calories: 598,
  fat: 58,
  protein: 98,
  carbs: 25,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566965299/rr35y2jxewozyig61a2g.jpg"
)

Dish.create!(
  name: 'Prawn curry',
  kitchen: kitchen_2,
  calories: 734,
  fat: 68,
  protein: 69,
  carbs: 40,
  remote_photo_url: "https://www.foodforfitness.co.uk/wp-content/uploads/2017/10/IMG_7262-2000x1333.jpg"
)

Dish.create!(
  name: 'Seafood soup',
  kitchen: kitchen_2,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://img.taste.com.au/4CIb5Btg/w720-h480-cfill-q80/taste/2016/11/italian-seafood-soup-with-garlic-croutons-88578-1.jpeg"
)
Dish.create!(
  name: 'Cheese pasta',
  kitchen: kitchen_2,
  calories: 798,
  fat: 79,
  protein: 54,
  carbs: 56,
  remote_photo_url: "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2011/11/14/0/FNM_120111-WN-Dinners-015_s4x3.jpg"
)

kitchen_2.dishes.take(5).each do |dish|
  DishPlan.create!(
    dish: dish,
    plan: plan_2
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
  remote_photo_url: "https://res.cloudinary.com/duj5vczom/image/upload/v1567078149/425003-svetik_aefk6u.jpg",
  user: hw_3,
  tag_list: ['japanese', 'high protein', 'nutritious', 'healthy'],
  konbini_id: Konbini.all.ids.sample
)

plan_3 = Plan.create!(
  name: 'weekdays plan',
  description: 'weekday balance lunch bento plan with varieties',
  price: 800,
  kitchen: kitchen_3,
  remote_photo_url: "https://www.eatright.org/-/media/eatrightimages/food/nutrition/nutritionfactsandfoodlabels/portion-serving-920931456.jpg",
  tag_list: ['japanese', 'high protein', 'nutritious']
)

Dish.create!(
  name: 'Maguro bento',
  kitchen: kitchen_3,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802230/cg4novwi51skxog6ojno.jpg"
)
Dish.create!(
  name: 'Tofu bento',
  kitchen: kitchen_3,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566965299/rr35y2jxewozyig61a2g.jpg"
)

Dish.create!(
  name: 'Prawn curry',
  kitchen: kitchen_3,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://www.foodforfitness.co.uk/wp-content/uploads/2017/10/IMG_7262-2000x1333.jpg"
)

Dish.create!(
  name: 'Seafood soup',
  kitchen: kitchen_3,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://img.taste.com.au/4CIb5Btg/w720-h480-cfill-q80/taste/2016/11/italian-seafood-soup-with-garlic-croutons-88578-1.jpeg"
)
Dish.create!(
  name: 'Cheese pasta',
  kitchen: kitchen_3,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2011/11/14/0/FNM_120111-WN-Dinners-015_s4x3.jpg"
)

kitchen_3.dishes.take(5).each do |dish|
  DishPlan.create!(
    dish: dish,
    plan: plan_3
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
  tag_list: ['high protein', 'nutritious', 'japanese'],
  konbini_id: Konbini.all.ids.sample
)

plan_4 = Plan.create!(
  name: 'Protein plan',
  description: 'weekday protein bento plan with varieties',
  price: 800,
  kitchen: kitchen_4,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566799058/aa8fdf9deed8ec996bddbe7ebe7afb0519ede164_hhnlrt.jpg",
  tag_list: ['japanese', 'high protein', 'nutritious']
)

Dish.create!(
  name: 'Maguro bento',
  kitchen: kitchen_4,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802230/cg4novwi51skxog6ojno.jpg"
)
Dish.create!(
  name: 'Tofu bento',
  kitchen: kitchen_4,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566965299/rr35y2jxewozyig61a2g.jpg"
)

Dish.create!(
  name: 'Prawn curry',
  kitchen: kitchen_4,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://www.foodforfitness.co.uk/wp-content/uploads/2017/10/IMG_7262-2000x1333.jpg"
)

Dish.create!(
  name: 'Seafood soup',
  kitchen: kitchen_4,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://img.taste.com.au/4CIb5Btg/w720-h480-cfill-q80/taste/2016/11/italian-seafood-soup-with-garlic-croutons-88578-1.jpeg"
)
Dish.create!(
  name: 'Cheese pasta',
  kitchen: kitchen_4,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2011/11/14/0/FNM_120111-WN-Dinners-015_s4x3.jpg"
)

kitchen_4.dishes.take(5).each do |dish|
  DishPlan.create!(
    dish: dish,
    plan: plan_4
  )
end

# -------------------
# -------------------
puts 'Creating housewife no.5 and its kitchen, plan, dishes'

hw_5= User.create!(
  email:'hw5@gmail.com',
  first_name: 'Eri',
  last_name: 'Shimada',
  password: "123123", #do not need to change
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566806362/Screen_Shot_2019-08-26_at_16.58.56_udc4go.png'
)

kitchen_5 = Kitchen.create!(
  name: 'Kids Happiness',
  description: 'Specialized in Kids bento',
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566956349/7787-00033-1_ktm0fj.jpg",
  user: hw_5,
  tag_list: ['kids', 'nutritious'],
  konbini_id: Konbini.all.ids.sample #do not need to change
)

plan_5 = Plan.create!(
  name: 'Kids bento plan',
  description: 'weekday nutritious kids bento plan',
  price: 800,
  kitchen: kitchen_5,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566806459/0f49b057_diutoo.jpg",
  tag_list: ['kids', 'nutritious']
)

Dish.create!(
  name: 'Maguro bento',
  kitchen: kitchen_5,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566802230/cg4novwi51skxog6ojno.jpg"
)
Dish.create!(
  name: 'Tofu bento',
  kitchen: kitchen_5,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566965299/rr35y2jxewozyig61a2g.jpg"
)

Dish.create!(
  name: 'Prawn curry',
  kitchen: kitchen_5,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://www.foodforfitness.co.uk/wp-content/uploads/2017/10/IMG_7262-2000x1333.jpg"
)

Dish.create!(
  name: 'Seafood soup',
  kitchen: kitchen_5,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://img.taste.com.au/4CIb5Btg/w720-h480-cfill-q80/taste/2016/11/italian-seafood-soup-with-garlic-croutons-88578-1.jpeg"
)
Dish.create!(
  name: 'Cheese pasta',
  kitchen: kitchen_5,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://food.fnr.sndimg.com/content/dam/images/food/fullset/2011/11/14/0/FNM_120111-WN-Dinners-015_s4x3.jpg"
)

kitchen_5.dishes.take(5).each do |dish|
  DishPlan.create!(
    dish: dish,
    plan: plan_5
  )
end

# -------------------

# -------------------
puts 'Creating housewife no.6 and its kitchen, plan, dishes'

hw_6= User.create!(
  email:'hw6@gmail.com',
  first_name: 'Grandma',
  last_name: 'Saotome',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566956113/Screen_Shot_2019-08-28_at_10.34.44_vg7l2f.png'
)

kitchen_6 = Kitchen.create!(
  name: 'Care bento',
  description: 'Everytime you open the bento, you will be suprised. These will remind you home.',
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566955026/CR_ANJ0453-700x466_rudmir.jpg",
  user: hw_6,
  tag_list: ['kids', 'nutritious'],
  konbini_id: Konbini.all.ids.sample
)

plan_6 = Plan.create!(
  name: 'Care bento plan',
  description: 'weekday character bento plan',
  price: 1000,
  kitchen: kitchen_6,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566814113/bento-box-eve1001520.jpg.1200x800_q85_crop_hxgzhw.jpg",
  tag_list: ['kids', 'nutritious']
)

Dish.create!(
  name: 'Mario bento',
  kitchen: kitchen_6,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566813659/0000001162_1_tw0v5g.jpg"
)
Dish.create!(
  name: 'Pikachu bento',
  kitchen: kitchen_6,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566814362/830c0df582fd42b52e0887d96364d5665ae7c0c1_cfggun.jpg"
)

Dish.create!(
  name: 'Kitty bento',
  kitchen: kitchen_6,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566814523/mm461_wtgf9n.jpg"
)

Dish.create!(
  name: 'Anpanman bento',
  kitchen: kitchen_6,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566814597/124075282737416413348_20090427_01x_anwwug.jpg"
)
Dish.create!(
  name: 'Snoopy bento',
  kitchen: kitchen_6,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://s3-ap-northeast-1.amazonaws.com/images.hintos.jp/wp-content/uploads/2017/08/09195007/obentopark_20170816_03-e1502243543135.jpg"
)

kitchen_6.dishes.take(5).each do |dish|
  DishPlan.create!(
    dish: dish,
    plan: plan_6
  )
end

# -------------------
# -------------------
puts 'Creating housewife no.7 and its kitchen, plan, dishes'

hw_7= User.create!(
  email:'hw7@gmail.com',
  first_name: 'Mika',
  last_name: 'Komori',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566814914/knb2001_detail031_z8bs8z.jpg'
)

kitchen_7 = Kitchen.create!(
  name: 'Wa bento',
  description: 'This is the authentic Japanese style of Bento',
  remote_photo_url: "https://res.cloudinary.com/duj5vczom/image/upload/v1567135627/healthy-cooking_zqiwbp.jpg",
  user: hw_7,
  tag_list: ['japanese','nutritious'],
  konbini_id: Konbini.all.ids.sample
)

plan_7 = Plan.create!(
  name: 'Osaka bento plan',
  description: 'weekday Wa bento plan',
  price: 1000,
  kitchen: kitchen_7,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566815469/pei-wei-bento-promo_v7b3kz.gif",
  tag_list: ['japanese','nutritious']
)

Dish.create!(
  name: 'Baked salmon bento',
  kitchen: kitchen_7,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566815050/new_xl_1488162889_4009_xjjrnh.jpg"
)
Dish.create!(
  name: 'Osechi bento',
  kitchen: kitchen_7,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566815587/598d5ce228726_amrbzv.jpg"
)

Dish.create!(
  name: 'Mixed bento',
  kitchen: kitchen_7,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566815717/bento180411_rmcsxz.jpg"
)

Dish.create!(
  name: 'Teriyaki bento',
  kitchen: kitchen_7,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566826503/japanese-bento-box_myesfv.jpg"
)
Dish.create!(
  name: 'Takikomi bento',
  kitchen: kitchen_7,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://s3-ap-northeast-1.amazonaws.com/testmorimalv2/img/Recipe-Image1-3141e99fb30e95d92cc3238cd125081385abea29b58a0710bb25ce6b74ae10d4f65.jpg"
)

kitchen_7.dishes.take(5).each do |dish|
  DishPlan.create!(
    dish: dish,
    plan: plan_7
  )
end

# -------------------
# -------------------
puts 'Creating housewife no.8 and its kitchen, plan, dishes'

hw_8= User.create!(
  email:'hw8@gmail.com',
  first_name: 'Kaori',
  last_name: 'Midoriyama',
  password: "123123",
  remote_photo_url: 'https://res.cloudinary.com/dxouryvao/image/upload/v1566827067/11412970_0_g2dhzz.jpg'
)

kitchen_8 = Kitchen.create!(
  name: 'Organic home',
  description: 'This is especially for those who wants food with fresh organic ingredients and richer in certain nutrients',
  remote_photo_url: "https://res.cloudinary.com/duj5vczom/image/upload/v1567134602/160311_smbzms.jpg",
  user: hw_8,
  tag_list: ['organic','healthy','nutritious'],
  konbini_id: Konbini.all.ids.sample
)

plan_8 = Plan.create!(
  name: 'Organic bento plan',
  description: 'weekday organic challenge plan',
  price: 1100,
  kitchen: kitchen_8,
  remote_photo_url: "https://res.cloudinary.com/duj5vczom/image/upload/v1567136069/LB_012midorie-10_960_570_dfueyc.jpg",
  tag_list: ['organic','healthy','nutritious']
)

Dish.create!(
  name: 'blessings of nature',
  kitchen: kitchen_8,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566829323/7287e7c3ee269234ead26299873ce4be_hyn6il.jpg"
)
Dish.create!(
  name: 'organic Wa bento',
  kitchen: kitchen_8,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566829533/51F316E2-750E-4B8C-8476-45B13D2205B4_txqd7i.jpg"
)

Dish.create!(
  name: 'low-carb organic bento',
  kitchen: kitchen_8,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566829781/image_ckleii.jpg"
)

Dish.create!(
  name: 'organic sand',
  kitchen: kitchen_8,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566830017/58bdb7fcbc8ebd22008b4769-750-563_c8yj6r.jpg"
)
Dish.create!(
  name: 'salad bowl',
  kitchen: kitchen_8,
  calories: 593,
  fat: 58,
  protein: 81,
  carbs: 29,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566830099/healthy-food-inspiration-instagram-e1432362958184_rbzjcw.jpg"
)

kitchen_8.dishes.take(5).each do |dish|
  DishPlan.create!(
    dish: dish,
    plan: plan_8
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
  # 2.times do
  Location.create!(
    label: ["Home", "Work"].sample,
    address: ["2-20-19, Shimomeguro, Meguro-ku, Tokyo", "1-3-3, Meguro, Meguro-ku, Tokyo", "1-21-20, Higashiyama, Meguro-ku, Tokyo", "‎2 Shimomeguro, Meguro-ku, Tokyo", "1-2-19, Shimomeguro, Meguro-ku, Tokyo", "2 Chome-20-8 Shimomeguro, Meguro City, Tokyo", "2-19-15 Kamimeguro, Meguro-ku, Tokyo", "1-8-1 Shimomeguro, Meguro-ku, Tokyo", "4-1-1 Shimomeguro, Meguro-ku, Tokyo", "2-4-36 Meguro, Meguro-ku, Tokyo"].sample,
    user: user  #real office addres e.g. Google, Amazon, Rakuten, Impacthub
  )
  # end
end

christee.locations.each do |location|
  location.destroy
end

Location.create!(
  label: "Work",
  address: "1-2-19, Shimomeguro, Meguro-ku, Tokyo",
  user: christee  #real office addres e.g. Google, Amazon, Rakuten, Impacthub
)

Location.create!(
  label: "Home",
  address: "5-1-1 Meijijingumae, Shibuya-ku, Tokyo",
  user: christee  #real office addres e.g. Google, Amazon, Rakuten, Impacthub
)

puts 'christee location made'


# puts 'Destroying 1kitchen-christee`s'


# puts "added #{Kitchen.count} kitchens."
# puts "added #{Location.count} locations."

# Kitchen.all.each do |kitchen|
#   rand(1..2).times do
#     Plan.create!(
#       name: Faker::Restaurant.type + ' plan',
#       price: [500,600, 700, 800, 900, 1000, 1100, 1200, 1300].sample,
#       kitchen: kitchen,
#       photo: open("https://source.unsplash.com/400x300/?healthy-food" || "https://source.unsplash.com/400x300/?dinner",)
#       description: Faker::Restaurant.description[0..100],
#       tag_list: tags_array.sample
#     )
#   end

#   rand(10..15).times do
#     Dish.create!(
#       name: Faker::Food.dish,
#       kitchen: kitchen,
#       photo: open("https://source.unsplash.com/400x300/?meal")
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
  rand(1..2).times do
    kitchen = Kitchen.where.not(user: user).sample
    plan = kitchen.plans.sample
    Order.create!(
      user: user,
      plan: plan,
      date: "2019-08-12, 2019-08-12, 2019-08-13, 2019-08-14",
      amount: plan.price*4
    )
  end
end

Order.create!(
  user: christee,
  plan: plan_4,
  date: "2019-08-19, 2019-08-20, 2019-08-21, 2019-08-22, 2019-08-23",
  amount: plan_4.price*5
)

Kitchen.all.each do |kitchen|
  rand(4..5).times do
    Review.create!(
      content: ['Very tasty bento, loved it!', 'Her lunch bento gives me motivation to go to work', 'I really like this kitchen, it tastes like home', 'Very healthy yummy bento. I have been subscribe for a while! I will continue', 'I like this kitchen, recommend it!'].sample,
      rating: [3,4,5].sample,
      kitchen: kitchen,
      user: [nath, shohei, huishu, doug, sylvain].sample
    )
  end
end


# puts "added #{Plan.count} Plans."
# puts "added #{Dish.count} dishes."


# end
# ---------------------------



puts "Seed is done!"
