class Statistic < ActiveRecord::Base
  # attr_accessible :game_id, :ratio, :repeats, :time, :user_id

  belongs_to :patients
  belongs_to :games

end
