namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(email: "example@railstutorial.org",
                 password: "foobar123",
                 password_confirmation: "foobar123")
    99.times do |n|
      email = "example-#{n+1}@railstutorial.org"
      password  = "password123"
      User.create!(email:email,
                   password: password,
                   password_confirmation: password)
    end
  end
end