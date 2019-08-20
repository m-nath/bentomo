# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "seed"

Kitchen.delete_all if Rails.env.development?
Order.delete_all if Rails.env.development?
Dish.delete_all if Rails.env.development?
Plan.delete_all if Rails.env.development?
Location.delete_all if Rails.env.development?
User.delete_all if Rails.env.development?

nath = User.create!(
  email: "nath@gmail.com",
  password: "123123",
  first_name: "Nath",
  last_name: "M",
  admin: true,
  remote_photo_url: "https://res.cloudinary.com/dxouryvao/image/upload/v1566268733/nath_q0kaa1.png"
)

christee = User.create!(
  email: "christee.song@gmail.com",
  password: "123123",
  first_name: "Christee",
  last_name: "Song",
  admin: true,
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
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw5_l5gr7w.jpg",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268732/hw6_dfhsv3.webp",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw1_qyo2vh.jpg",
   "https://res.cloudinary.com/dxouryvao/image/upload/v1566268731/hw4_unvhly.jpg"]

9.times do
  User.create!(email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: "123123", remote_photo_url: avatar.sample)
end

puts "added #{User.count} users."

User.all.each do |user|
  rand(1..3).times do
    e = Kitchen.create!(
      name: Faker::Restaurant.name,
      description: Faker::Food.description,
      photo: "https://source.unsplash.com/1000x700/?food",
      konbini: ["Lawson Shibuya", "Family-mart Shinjuku", "Seven-eleven Meguro", "Lawson Jingu-mae"].sample,
      user: user
    )
    puts "created #{e.name}"

  end
  rand(1..3).times do
    Plan.create!(
      user: user,
      kitchen: Kitchen.all.sample
    )
  end
end
puts "added #{Kitchen.count} events."

puts "Seed is done!"
