class PatientsController < ApplicationController
    before_filter :signed_in_user , only: [:show, :update, :edit]
    before_filter :correct_user, only: [:show, :update, :edit]
    before_filter :admin_user, only: [:index]
    before_filter :correct_therapist, only: [:show_details_to_therapist]
    respond_to :html, :json

    def show
        if Patient.exists?(params[:id])
            @patient = Patient.find(params[:id])
            @games = @patient.get_recomnded_games
            @instruction_details = @patient.get_instruction_details
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
    	@patient = parse_params_to_new_patient(params)
    	if @patient.save
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
        respond_to do |format|
            @patient.attributes = params[:patient]
            @patient.save(:validate => false)
            format.json {respond_with @patient }
            format.html do 
                sign_in @patient
                redirect_to @patient
            end
            @patient.errors.full_messages.each do |msg| 
                puts msg 
            end
        end
    end

    def index
        @patients = Patient.all.paginate(:page => params[:page], :per_page => 10)
    end

    def destroy
        Patient.find(params[:id]).destroy
        flash[:success] = "Patient destroyed"
        redirect_to therapist_path(current_user)
    end

    def show_details_to_therapist
        @patient = Patient.find(params[:id])
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

    def correct_therapist
        @user = User.find(params[:id])
        unless current_user_therapist?(@user) or current_user.admin?
            redirect_to(root_path)
        end
    end

    def admin_user
        redirect_to(root_path) unless current_user.admin?
    end

    def parse_params_to_new_patient(params)
        year = params[:patient]["age(1i)"].to_i
        month = params[:patient]["age(2i)"].to_i
        day = params[:patient]["age(3i)"].to_i
        date_of_birth = Date.new(year, month, day)
        params[:patient][:date_of_birth] = date_of_birth
        Patient.new(params[:patient].except("age(1i)", "age(2i)", "age(3i)"))
    end
end
