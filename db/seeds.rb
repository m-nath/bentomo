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

puts "creating users with photos"

nath = User.create!(
  email: "nath@gmail.com",
  password: "123123",
  first_name: "Nath",
  last_name: "M",
  admin: false,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268733/nath_q0kaa1.png"
)

christee = User.create!(
  email: "christee.song@gmail.com",
  password: "123123",
  first_name: "Christee",
  last_name: "Song",
  admin: false,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268919/51040522_mxitwx.jpg"
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
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/doug_hwhpw6.png"
)

sylvain = User.create!(
  email: "sylvain@gmail.com",
  password: "123123",
  first_name: "Sylvain",
  last_name: "Pierre",
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/sylvain_q1ry1x.png"
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
    remote_photo_url: "https://source.unsplash.com/1000x700/?healthy-food",
    konbini: "Family-mart Meguro",
    user: demo_hw
  )

9.times do
  User.create!(email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: "123123", remote_photo_url: avatar.sample)
end


puts "added #{User.count} users."

User.all.each do |user|
  e = Kitchen.create!(
    name: Faker::Restaurant.name,
    description: Faker::Restaurant.description,
    remote_photo_url: "https://source.unsplash.com/1000x700/?lunch",
    konbini: ["Lawson Shibuya", "Family-mart Shinjuku", "Family-mart Meguro", "Mybasket Meguro", "Seven-eleven Meguro", "Lawson Jingu-mae"].sample,
    user: user
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

Kitchen.last(3).map(&:destroy)

puts "added #{Kitchen.count} kitchens."
puts "added #{Location.count} locations."


Kitchen.all.each do |kitchen|
  rand(1..3).times do
    Plan.create!(
      name: Faker::Restaurant.type,
      price: [2000, 3000, 4000, 5000, 2500, 3500, 4500, 2300, 2800, 3800, 3200, 4200, 4800].sample,
      kitchen: kitchen,
      remote_photo_url: "https://source.unsplash.com/1000x700/?dinner" || "https://source.unsplash.com/1000x700/?healthy-food" ,
      description: Faker::Restaurant.description,
    )
  end

  rand(5..8).times do
    Dish.create!(
      name: Faker::Food.dish,
      kitchen: kitchen,
      remote_photo_url: "https://source.unsplash.com/1000x700/?meal"
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
      amount: plan.price,
      user: user,
      plan: plan,
      date: Faker::Time.between_dates(from: Date.today, to: Date.today + 7, period: :morning, format: :short)
    )
  # create order for past
  rand(2..4).times do
    kitchen = Kitchen.where.not(user: user).sample
    plan = kitchen.plans.sample
    Order.create!(
      amount: plan.price,
      user: user,
      plan: plan,
      date: Faker::Time.between_dates(from: Date.today - 60, to: Date.today - 7, period: :morning, format: :short)
    )
  end
end

puts "added #{Plan.count} Plans."

puts "added #{Dish.count} dishes."



puts "Seed is done!"
