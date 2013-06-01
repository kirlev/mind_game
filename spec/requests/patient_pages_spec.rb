require 'spec_helper'

describe "PatientPages" do
  
  subject { page }

  describe "profile page" do
    let(:patient) { FactoryGirl.create(:patient) }
    before { visit patient_path(patient) }

    it { should have_selector('h1',    text: patient.first_name) }
    it { should have_selector('title', text: patient.first_name) }
  end

  describe "patient signup" do

    before { visit patient_signup_path }

    let(:submit) { "Create patient account" }

    describe "with invalid information" do
      it "should not create a patient" do
        expect { click_button submit }.not_to change(Patient, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "First name",         with: "Example"
        fill_in "Last name",         with: "Patient"
        fill_in "Username",         with: "blabla"
        fill_in "Age",        with: "55"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a patient" do
        expect { click_button submit }.to change(Patient, :count).by(1)
      end
    end
  end

end
