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

      describe "after saving the patient" do
        before { click_button submit }
        let(:patient) { Patient.find_by_username('blabla') }

        it { should have_selector('title', text: patient.first_name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "edit" do
    let(:patient) { FactoryGirl.create(:patient) }
    before { visit edit_patient_path(patient) }

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit patient") }
      #it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      before do
        fill_in "Password",         with: patient.password
        fill_in "Confirm Password", with: patient.password
        click_button "Save changes"
      end

      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
    end
  end

  describe "index" do
    before do
      sign_in FactoryGirl.create(:patient)
      FactoryGirl.create(:patient, first_name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:patient, first_name: "Ben", email: "ben@example.com")
      visit patients_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    it "should list each user" do
      Patient.all.each do |patient|
        page.should have_selector('li', text: patient.first_name)
      end
    end
  end


end
