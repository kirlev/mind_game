class PatientsController < ApplicationController
    def show
        @patient = Patient.find(params[:id])
    end

    def new
    	@patient = Patient.new
    end

    def create
    	@patient = Patient.new(params[:patient])
    	if @patient.save
    		flash[:success] = "Welcome to Brain Tracker!"
    		redirect_to @patient
    	else
    		render 'new'
    	end
    end
end
