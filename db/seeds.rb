Order.destroy_all if Rails.env.development?
DishPlan.destroy_all if Rails.env.development?
Kitchen.destroy_all if Rails.env.development?
Plan.destroy_all if Rails.env.development?
Location.destroy_all if Rails.env.development?
User.destroy_all if Rails.env.development?
Dish.destroy_all if Rails.env.development?

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
