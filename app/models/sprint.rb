class Sprint < ActiveRecord::Base
  has_many :tasks
  belongs_to :user
  attr_accessible :team_id, :user_id, :name
end