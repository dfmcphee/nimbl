class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation, :remember_me
  
  has_many :assignments
  has_many :notifications
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :username
  validates_uniqueness_of :username
  
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def is_manager?
  	if (self.has_role? :admin) || (self.has_role? :product_owner) || (self.has_role? :scrum_master)
      return true
    else
      return false
    end
  end
end