class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :email, use: :slugged
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :roles
  has_many :programs, through: :roles


  # user types
  # do not modify this array unless modifying the types of users
  TYPES = {:superuser => 3, :admin => 2, :staff => 1, :student => 0}.freeze
  def is_superuser?
    (superuser == true) ? true : false
  end
end
