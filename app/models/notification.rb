class Notification < ActiveRecord::Base
  attr_accessible :message, :read, :user_id
  belongs_to :user
end