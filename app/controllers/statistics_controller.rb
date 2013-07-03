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
end
