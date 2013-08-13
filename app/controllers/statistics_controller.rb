class StatisticsController < ApplicationController
	respond_to :json

  def create
  	@statistic = Statistic.new(params[:statistic])

  	if(@statistic.save)
  		render :nothing => true
  	else
  		render :status => :forbidden
  	end
  end

  def show
  	@patient = Patient.find(params[:statistic][:user_id])
  	@data = @patient.get_statistics(params[:statistic][:game_id])
  	respond_with @data
  end
end
