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
    has_many :games, :through => :statistics

	validates :therapist_id, presence: true


	def get_ratio_statistics(game_id)
		stats=Statistic.where(game_id: game_id, user_id: id).order(:created_at)
    results= stats.map { |stat| [stat.created_at.to_i, stat.ratio] }
    p "-"*100
    p results
    results.to_json
	end

end
