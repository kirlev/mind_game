class Instruction < ActiveRecord::Base
  belongs_to :patient

  def get_games
  	result = self.games_id.split(",")
  	result.map { |x| x.to_i }
  end
end
