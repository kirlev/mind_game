require 'will_paginate/array'
class TherapistsController < ApplicationController
    before_filter :signed_in_user, only: [:show, :update, :edit]
    before_filter :correct_user, only: [:show, :update, :edit]
    before_filter :admin_user, only: [:index, :destroy]

	def show
        if Therapist.exists?(params[:id])
            @therapist = Therapist.find(params[:id])
            @patients = Patient.find(:all, :conditions => ["therapist_id = ?", @therapist.id], :order => "last_login desc").paginate(:page => params[:page], :per_page => 10)
        elsif Therapist.count > params[:id].to_i
            redirect_to therapist_path(params[:id].to_i + 1)
        else
            redirect_to root_path
        end
        
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

    def destroy
        Therapist.find(params[:id]).destroy
        flash[:success] = "Therapist destroyed"
        redirect_to therapists_url
    end

    private

    def signed_in_user
        store_location
        redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
        @user = User.find_by_id(params[:id])
        unless current_user?(@user) or current_user.admin?
            redirect_to(root_path)
        end
    end

    def admin_user
        redirect_to(root_path) unless current_user.admin?
    end

end
