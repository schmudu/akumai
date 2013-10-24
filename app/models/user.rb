class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # user types
  # do not modify this array unless modifying the types of users
  TYPES = {:superuser => 3, :admin => 2, :staff => 1, :student => 0}.freeze
  def is_superuser?
=begin
    return true if (superuser == true) 
    false
=end
    (superuser == true) ? true : false
  end

=begin
  def self.superuser
    TYPES[:superuser]
  end
=end
end
