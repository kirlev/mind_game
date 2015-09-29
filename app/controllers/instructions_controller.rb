class InstructionsController < ApplicationController

  def create
  	params[:instruction][:games_id] = params[:instruction][:games_id].drop(1)
  	params[:instruction][:games_id] = params[:instruction][:games_id].join(",")
  	puts params[:instruction][:games_id]
	@instruction = Instruction.new(params[:instruction].permit(:details,:games_id,:patient_id))

  	if @instruction.save
  		render :nothing => true
  	else
  		render :status => :forbidden
  	end
  end
end
