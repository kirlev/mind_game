require 'spec_helper'

describe "TherapistPages" do
  
  subject { page }

  describe "profile page" do
    let(:therapist) { FactoryGirl.create(:therapist) }
    before { visit therapist_path(therapist) }

    it { should have_selector('h1',    text: therapist.first_name) }
    it { should have_selector('title', text: therapist.first_name) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a therapist" do
        expect { click_button submit }.not_to change(Therapist, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Username",         with: "username"
        fill_in "First name",         with: "Example"
        fill_in "Last name",         with: "Therapist"
        fill_in "Hospital name",         with: "blabla"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a therapist" do
        expect { click_button submit }.to change(Therapist, :count).by(1)
      end

      describe "after saving the therapist" do
        before { click_button submit }
        let(:therapist) { Therapist.find_by_username('username') }

        it { should have_selector('title', text: therapist.first_name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

end
