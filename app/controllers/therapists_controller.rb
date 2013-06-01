class TherapistsController < ApplicationController
	def show
        @therapist = Therapist.find(params[:id])
    end

    def new
    	@therapist = Therapist.new
    end

    def create
    	@therapist = Therapist.new(params[:therapist])
    	if @therapist.save
    		flash[:success] = "Welcome to the Brain Tracker!"
    		redirect_to @therapist
    	else
    		render 'new'
    	end
    end

end
