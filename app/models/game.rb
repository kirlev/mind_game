class Game < ActiveRecord::Base
  attr_accessible :developer, :name
  has_many :statistics
  has_many :patients, :through => :statistics
end
