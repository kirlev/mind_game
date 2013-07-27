class PatientsController < ApplicationController
    before_filter :signed_in_user , only: [:show, :update, :edit]
    before_filter :correct_user, only: [:show, :update, :edit]
    before_filter :admin_user, only: [:index]

    def show
        if Patient.exists?(params[:id])
            @patient = Patient.find(params[:id])
        elsif Patient.count > params[:id].to_i
            redirect_to patient_path(params[:id].to_i + 1)
        else
            redirect_to root_path
        end
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

    def destroy
        Patient.find(params[:id]).destroy
        flash[:success] = "Patient destroyed"
        redirect_to therapist_path(current_user)
    end

    private

    def signed_in_user
        store_location
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
        @user = User.find(params[:id])
        unless current_user?(@user) or current_user_therapist?(@user) or current_user.admin?
            redirect_to(root_path)
        end
    end

    def admin_user
        redirect_to(root_path) unless current_user.admin?
    end
end
