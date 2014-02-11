require_relative '../../app/helpers/constants_helper'

namespace :db do
  # run via: rake db:populate
  desc "Fill database with sample data"
  task populate: :environment do
    @superuser = User.create!(email: "superuser@abc.com", password: "foobar123", password_confirmation: "foobar123", superuser:true)
    @user_admin = User.create!(email: "admin@abc.com", password: "foobar123", password_confirmation: "foobar123", superuser:true)
    @user_staff = User.create!(email: "staff@abc.com", password: "foobar123", password_confirmation: "foobar123", superuser:true)
    @user_student = User.create!(email: "student@abc.com", password: "foobar123", password_confirmation: "foobar123", superuser:true)
    @program = Program.create!(name:"brand new program")
    Role.create!(:user_id => @user_admin.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_ADMIN, :student_id => nil)
    Role.create!(:user_id => @user_staff.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STAFF, :student_id => nil)
    Role.create!(:user_id => @user_student.id, :program_id => @program.id, :level => ConstantsHelper::ROLE_LEVEL_STUDENT, :student_id => "a001")
=begin
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
    99.times do |n|
      name = "Name_#{n}"
      Program.create!(name:name)
    end
=end
  end
end