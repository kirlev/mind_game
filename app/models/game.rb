class Game < ActiveRecord::Base
  has_many :statistics
  has_many :patients, :through => :statistics
end
