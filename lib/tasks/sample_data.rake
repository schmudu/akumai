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

namespace :test do
  #run via: rake RAILS_ENV=development test:create_invite
  desc "Create test invitation and invite"
  task create_invite_staff: :environment do
    @superuser = User.find_by_email("superuser@abc.com")
    @program = Program.first
    if @superuser.nil? || @program.nil?
      puts "Need program and superuser to complete this task #{environment}"
      next
    end
    @invitation = Invitation.new
    @invitation.name = "Random Invitation"
    @invitation.creator_id = @superuser.id
    @invitation.program_id = @program.id
    @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
    @invitation.recipient_emails = ""
    @invitation.status = ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
    @invitation.save
    @invite = Invite.new
    @invite.code = "abc"
    @invite.email = "doodle@abc.com"
    @invite.student_id = "abc01"
    @invite.user_level = ConstantsHelper::ROLE_LEVEL_STAFF
    @invite.invitation_id = @invitation.id
    @invite.save
  end

  desc "Create test invitation and invite for student"
  task create_invite_student: :environment do
    @superuser = User.find_by_email("superuser@abc.com")
    @program = Program.first
    if @superuser.nil? || @program.nil?
      puts "Need program and superuser to complete this task #{environment}"
      next
    end
    @invitation = Invitation.new
    @invitation.name = "Random Invitation"
    @invitation.creator_id = @superuser.id
    @invitation.program_id = @program.id
    @invitation.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
    @invitation.recipient_emails = ""
    @invitation.status = ConstantsHelper::INVITATION_STATUS_SETUP_TYPE
    @invitation.save
    @invite = Invite.new
    @invite.code = "abc"
    @invite.email = "doodle@abc.com"
    @invite.student_id = "abc01"
    @invite.user_level = ConstantsHelper::ROLE_LEVEL_STUDENT
    @invite.invitation_id = @invitation.id
    @invite.save
  end
end