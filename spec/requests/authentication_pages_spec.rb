require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "therapist with valid information" do
      let(:user) { FactoryGirl.create(:therapist) }
      before { sign_in user }

      it { should have_selector('title', text: user.first_name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Settings', href: edit_therapist_path(user)) }
    end

    describe "patient with valid information" do
      let(:user) { FactoryGirl.create(:patient) }
      before { sign_in user }

      it { should have_selector('title', text: user.first_name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
      it { should have_link('Settings', href: edit_patient_path(user)) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
     
      describe "in the Users controller" do
       
        describe "visiting the patient index" do
          before { visit patients_path }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "visiting the therapist index" do
          before { visit therapists_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end
     
    end
  end

end
