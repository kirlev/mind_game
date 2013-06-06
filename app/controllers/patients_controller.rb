class PatientsController < ApplicationController
    before_filter :signed_in_user, only: [:index, :edit, :update]

    def show
        @patient = Patient.find(params[:id])
    end

    def new
        @therapist_id = params[:patient][:therapist_id]
        @patient = Patient.new(params[:patient])
    end

    def create
    	@patient = Patient.new(params[:patient])
    	if @patient.save
            #sign_in @patient
    		#flash[:success] = "Welcome to Brain Tracker!"
            flash[:success] = "Added new patient"
    		redirect_to Therapist.find(params[:patient][:therapist_id])
    	else
            @therapist_id = params[:patient][:therapist_id]
    		render 'new'
    	end
    end

    def edit
        @patient = Patient.find(params[:id])
    end

    def update
        @patient = Patient.find(params[:id])
        if @patient.update_attributes(params[:patient])
            flash[:success] = "Profile updated"
            sign_in @patient
            redirect_to @patient
        else
            render 'edit'
        end
    end

    def index
        @patients = Patient.all
    end

    private

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
end
