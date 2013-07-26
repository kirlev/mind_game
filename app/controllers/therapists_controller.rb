class TherapistsController < ApplicationController
    before_filter :signed_in_user, only: [:show, :update, :edit, :index]
    before_filter :correct_user, only: [:show, :update, :edit, :index]

	def show
        @therapist = Therapist.find(params[:id])
        @patients = Patient.find(:all, :conditions => ["therapist_id = ?", @therapist.id])
    end

    def new
    	@therapist = Therapist.new
    end

    def create
    	@therapist = Therapist.new(params[:therapist])
    	if @therapist.save
            sign_in @therapist
    		flash[:success] = "Welcome to the Brain Tracker!"
    		redirect_to @therapist
    	else
    		render 'new'
    	end
    end

    def edit
        @therapist = Therapist.find(params[:id])
    end

    def update
        @therapist = Therapist.find(params[:id])
        if @therapist.update_attributes(params[:therapist])
            flash[:success] = "Profile updated"
            sign_in @therapist
            redirect_to @therapist
        else
            render 'edit'
        end
    end

    def index
        @therapists = Therapist.all
    end

    private

    def signed_in_user
        store_location
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
        @user = User.find(params[:id])
        unless corrent_user?(@user)
            redirect_to(root_path)
        end
    end

end
