# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# populate Tags
%w(feature TODO bug).each do |tag|
  Tag.create(name: tag)
end

# create Users
User.create(first_name: 'Админ', last_name: 'Админыч', email: 'admin@admin.com', is_admin: true, nickname: 'bond007')

10.times do |n|
  User.create(first_name: Faker::Name.unique.first_name,
              last_name: Faker::Name.unique.last_name,
              email: "user#{n + 1}@email.com",
              nickname: Faker::Internet.unique.user_name
              # password: 11111111,
              # password_confirmation: 11111111
  )
end
