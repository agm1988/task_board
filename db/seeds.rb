# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# populate Tags
%w(feature TODO bug).each do |tag|
  Tag.create!(name: tag)
end

# create Users
puts 'Creating admin'
User.create!(
  first_name: 'Админ',
  last_name: 'Админыч',
  email: 'admin@admin.com',
  is_admin: true,
  nickname: 'bond007',
  work_start_time: '10:00',
  password: 11111111,
  password_confirmation: 11111111)

puts "\n Done creating admin"

puts 'Creating Users'
10.times do |n|
  print '.'
  User.create!(first_name: Faker::Name.unique.first_name,
              last_name: Faker::Name.unique.last_name,
              email: "user#{n + 1}@email.com",
              nickname: Faker::Internet.unique.user_name,
              work_start_time: "#{rand(24)}:#{rand(60)}",
              password: 11111111,
              password_confirmation: 11111111
  )
end
puts "\n Done Creating Users"

puts 'Creating Reports'
200.times do |_n|
  print '.'
  Report.create!(
    FactoryGirl.attributes_for(:report).merge(
      user: User.find(rand(1..10)),
      status: rand(2)
    )
  )
end
puts "\n Done Creating Reports"

puts 'Creating Comments'
commentables = [Task, Report]
user_ids = User.pluck(:id)
666.times do |_n|
  print '.'
  commentable = commentables.sample
  size = commentable.count

  Comment.create!(
    body: Faker::Lorem.unique.sentence(rand(27)),
    commentable: commentable.find(rand(1..size)),
    user_id: user_ids.shuffle[0]
  )
end
puts "\n Done Creating Comments"

puts 'All done, yay :)'
