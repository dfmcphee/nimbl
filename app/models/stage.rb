class Stage < ActiveRecord::Base
  attr_accessible :name
  has_many :task_stages
end
