# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  hospital_name   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  username        :string(255)
#  age             :integer
#  type            :string(255)
#

class Patient < User

	has_many :statistics
	has_many :instructions
    has_many :games, :through => :statistics

	validates :therapist_id, presence: true


	def get_statistics(game_id)
		stats=Statistic.where(game_id: game_id, user_id: id).order(:created_at)
    ratioArray = stats.map { |stat| [stat.created_at.to_i, stat.ratio] }
    repeatsArray = stats.map { |stat| [stat.created_at.to_i, stat.repeats] }
    timeArray = stats.map { |stat| [stat.created_at.to_i, stat.time] }
    result = [ratioArray, repeatsArray, timeArray]
    p "-"*100
    p result
    result.to_json
	end

	def get_recomnded_games
		games_id_array = last_instruction.games_id.split(',').map { |x| x.to_i }
		return Game.find(games_id_array)
	end

	def get_instruction_details
		return last_instruction.details
	end

	private

	def last_instruction
		return Instruction.where(patient_id: id).order(:created_at).last
	end

end



