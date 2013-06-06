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

  describe "edit" do
    let(:therapist) { FactoryGirl.create(:therapist) }
    before { visit edit_therapist_path(therapist) }

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit therapist") }
      #it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_first_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "First name",             with: new_first_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: therapist.password
        fill_in "Confirm Password", with: therapist.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_first_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { therapist.reload.first_name.should  == new_first_name }
      specify { therapist.reload.email.should == new_email }
    end
  end

  describe "index" do
    before do
      sign_in FactoryGirl.create(:therapist)
      FactoryGirl.create(:therapist, first_name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:therapist, first_name: "Ben", email: "ben@example.com")
      visit therapists_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    it "should list each user" do
      Therapist.all.each do |therapist|
        page.should have_selector('li', text: therapist.first_name)
      end
    end
  end

end
