# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do |t|
  User.create(user_name: Faker::Name.name)
end

10.times do |t|
  Poll.create(title: Faker::Book.title, user_id: Faker::Number.between(1,10))
end

10.times do |t|
  Question.create(poll_id: Faker::Number.between(1,10), text: Faker::Hipster.sentences)
end

40.times do |t|
  AnswerChoice.create(question_id: Faker::Number.between(1,10), text: Faker::Hipster.sentences)
end

70.times do |t|
  Response.create(user_id: Faker::Number.between(1,10), answer_choice_id: Faker::Number.between(1,40))
end
