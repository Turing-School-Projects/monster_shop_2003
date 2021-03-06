require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

#merchants
# bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
# dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
# Merchant.create(name: "Mike's Shop", address: '100 Lane Rd.', city: 'Denver', state: 'CO', zip: 80203)

faker_merchants = []

10.times do
  merchant = Merchant.create(
    name: Faker::Company.unique.name,
    address: Faker::Address.street_address,
    city:Faker::Address.city,
    state:Faker::Address.state,
    zip:Faker::Address.zip.to_i,
  )
  faker_merchants << merchant
end

faker_merchants.each_with_index do |fake_merchant, index|
  fake_merchant.users.create(
    name: "Employee#{index}",
    address: "555 Main St.",
    city: "Louisville",
    state: "CO",
    zip: 80027,
    email: "employee#{index}@gmail.com",
    password: "employee",
    role: 1
  )


  10.times do |n|
    fake_merchant.items.create(
      name: Faker::Beer.name,
      description: Faker::Beer.style,
      price: rand(10),
      image: "https://loremflickr.com/300/350/beer,mug,alcohol/all?lock=#{rand(1000)}",
      inventory: rand(50)
    )
  end
end

# Users
taylor = User.create(name: "Taylor",
  address: "555 Main St.",
  city: "Louisville",
  state: "Co",
  zip: 80027,
  email: "t.keller@gmail.com",
  password: "taylor",
  role: 0)

ana = User.create(name: "Ana",
  address: "555 Main St.",
  city: "Louisville",
  state: "Co",
  zip: 80027,
  email: "ana@gmail.com",
  password: "ana",
  role: 0)

# Admin
User.create(name: "Admin",
  address: "555 Main St.",
  city: "Louisville",
  state: "CO",
  zip: 80027,
  email: "admin@gmail.com",
  password: "admin",
  role: 2)

users = []

10.times do
  new_user = User.create(
    name: Faker::Name.unique.name,
    address: Faker::Address.street_address,
    city:Faker::Address.city,
    state:Faker::Address.state,
    zip:Faker::Address.zip.to_i,
    email: Faker::Name.unique.first_name + "#{rand(25)}@gmail.com",
    password: "user",
    role: 0
  )
    users << new_user
end

# Orders

order1 = Order.create(
  name: "Taylor",
  address: Faker::Address.street_address,
  city:Faker::Address.city,
  state:Faker::Address.state,
  zip:Faker::Address.zip.to_i,
  user_id: taylor.id,
)

order2 = Order.create(
  name: "Taylor",
  address: Faker::Address.street_address,
  city:Faker::Address.city,
  state:Faker::Address.state,
  zip:Faker::Address.zip.to_i,
  user_id: taylor.id,
  status: "shipped"
)

order3 = Order.create(
  name: "Taylor",
  address: Faker::Address.street_address,
  city:Faker::Address.city,
  state:Faker::Address.state,
  zip:Faker::Address.zip.to_i,
  user_id: taylor.id,
  status: "cancelled"
)

order4 = Order.create(
  name: "Ana",
  address: Faker::Address.street_address,
  city:Faker::Address.city,
  state:Faker::Address.state,
  zip:Faker::Address.zip.to_i,
  user_id: ana.id,
)

order5 = Order.create(
  name: "Ana",
  address: Faker::Address.street_address,
  city:Faker::Address.city,
  state:Faker::Address.state,
  zip:Faker::Address.zip.to_i,
  user_id: ana.id,
  status: "packaged"
)

orders = [order1, order2, order3, order4, order5]

# ItemOrders
orders.each do |order|
  rand(10).times do |n|
    ItemOrder.create(
      order_id: order.id,
      item_id: faker_merchants[n].items[n].id,
      price: faker_merchants[n].items[n].price,
      quantity: rand(10)
    )
  end
end

fake_orders = []

20.times do
  new_order = Order.create(
    name: Faker::Name.name,
    address: Faker::Address.street_address,
    city:Faker::Address.city,
    state:Faker::Address.state,
    zip:Faker::Address.zip.to_i,
    user_id: users.sample.id,
  )
  fake_orders << new_order
end

fake_orders.each do |order|
  rand(8).times do |n|
    ItemOrder.create(
      order_id: order.id,
      item_id: faker_merchants[n].items[n].id,
      price: faker_merchants[n].items[n].price,
      quantity: rand(10)
    )
  end
end



# #bike_shop items
# tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
#
# #dog_shop items
# pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "https://lh3.googleusercontent.com/proxy/8ngyjw7p9EZhRkkexSlckUdQl8AR0MXwc-n9GkDPbCvcdP0deqBIqHc8-TRdTMqkJEqBDAXiJ6y5ZnkDN-lmzckmh6unqgKrjdYHByHUt18F5mAZFNeyUQFznjZPM4-x0_gkJZAPTnd0vSYx8xp56fd00pc", inventory: 32)
# dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)



# meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
# brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
#
# tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 50)
# dragon = meg.items.create(name: "Dragon", description: "Guards your treasure as if it were its own.", price: 60, image: "https://images-na.ssl-images-amazon.com/images/I/51B9mwNncrL._AC_.jpg", inventory: 60)
# werewolf = meg.items.create(name: "Werewolf", description: "Knows when a full moon is on the rise.", price: 60, image: "https://ih1.redbubble.net/image.765064972.3394/throwpillow,small,750x600-bg,f8f8f8.jpg", inventory: 60)
# griffin = meg.items.create(name: "Griffin", description: "Will take you places.", price: 60, image: "https://m.media-amazon.com/images/I/91e1B5e8jIL._SR500,500_.jpg", inventory: 60)
# mermaid = meg.items.create(name: "Mermaid", description: "Be a mermaid from the comfort of your own home.", price: 60, image: "https://secure.img1-fg.wfcdn.com/im/59218715/resize-h800-w800%5Ecompr-r85/9053/90537369/Rosas+Kids+Mermaid+Tail+Blanket.jpg", inventory: 60)
#
# pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 30)
# dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 20)
# frankenstein = brian.items.create(name: "Frankenstein", description: "Great read!", price: 20, image: "https://i.ebayimg.com/images/g/4A8AAOSwj9RenuF5/s-l300.jpg", inventory: 20)
# cthulhu = brian.items.create(name: "Cthulhu", description: "Great gift!", price: 20, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQP11jyikd5WuCr4Ag4RK5uCn0NMoIee3IhkW3ZQV9w0-7MKSIA&usqp=CAU", inventory: 20)
# fairy = brian.items.create(name: "Fairy", description: "Sprinkle a little and spread your wings", price: 20, image: "https://i.etsystatic.com/6759919/r/il/806b42/1188540485/il_570xN.1188540485_fbhk.jpg", inventory: 20)
#
# order_1 = Order.create(name: "Fiona", address: "123 Top Of The Tower", city: "Duloc City", state: "Duloc State", zip: 10001, user_id: user.id)
#
# ItemOrder.create(order_id: order_1.id, item_id: fairy.id, price: 50, quantity: 6)
# ItemOrder.create(order_id: order_1.id, item_id: tire.id, price: 50, quantity: 10)
# ItemOrder.create(order_id: order_1.id, item_id: werewolf.id, price: 50, quantity: 9)
# ItemOrder.create(order_id: order_1.id, item_id: cthulhu.id, price: 50, quantity: 7)
# ItemOrder.create(order_id: order_1.id, item_id: mermaid.id, price: 50, quantity: 8)
# ItemOrder.create(order_id: order_1.id, item_id: dog_bone.id, price: 50, quantity: 3)
# ItemOrder.create(order_id: order_1.id, item_id: griffin.id, price: 50, quantity: 4)
# ItemOrder.create(order_id: order_1.id, item_id: frankenstein.id, price: 50, quantity: 2)
# ItemOrder.create(order_id: order_1.id, item_id: pull_toy.id, price: 50, quantity: 1)
# ItemOrder.create(order_id: order_1.id, item_id: dragon.id, price: 50, quantity: 5)
