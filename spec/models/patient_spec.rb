# == Schema Information
#
# Table name: patients
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  age             :integer
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Patient do

  before { @patient = Patient.new(username: "user", first_name: "Example", last_name: "Patient",
                         age: "55", password: "foobar", password_confirmation: "foobar") }

  subject { @patient }

  it { should respond_to(:username) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }  
  it { should respond_to(:password_digest) }  
  it { should respond_to(:age) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when username is not present" do
    before { @patient.username = " " }
    it { should_not be_valid }
  end
  #describe "when first name is not present" do
  #  before { @patient.first_name = " " }
  #  it { should_not be_valid }
  #end
  #describe "when last name is not present" do
  #  before { @patient.last_name = " " }
  #  it { should_not be_valid }
  #end
  #describe "when age is not present" do
  #  before { @Patient.age = " " }
  #  it { should_not be_valid }
  #end 

  describe "when age is not an integer" do
    before { @patient.age = "string" }
    it { should_not be_valid }
  end 

  describe "when password is not present" do
    before { @patient.password = @patient.password_confirmation = " " }
    it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
    before { @patient.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  describe "when password confirmation is nil" do
    before { @patient.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @patient.save }
    let(:found_patient) { Patient.find_by_username(@patient.username) }

    describe "with valid password" do
      it { should == found_patient.authenticate(@patient.password) }
    end

    describe "with invalid password" do
      let(:patient_for_invalid_password) { found_patient.authenticate("invalid") }

      it { should_not == patient_for_invalid_password }
      specify { patient_for_invalid_password.should be_false }
    end
  end


  describe "when first name is too long" do
    before { @patient.first_name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when last name is too long" do
    before { @patient.last_name = "b" * 51 }
    it { should_not be_valid }
  end

  #describe "when email format is invalid" do
  #  it "should be invalid" do
  #    addresses = %w[therapist@foo,com therapist_at_foo.org example.therapist@foo.
  #                   foo@bar_baz.com foo@bar+baz.com]
  #    addresses.each do |invalid_address|
  #     @therapist.email = invalid_address
  #      @therapist.should_not be_valid
  #    end      
  #  end
  #end

  #describe "when email format is valid" do
  #  it "should be valid" do
  #    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  #    addresses.each do |valid_address|
  #      @therapist.email = valid_address
  #      @therapist.should be_valid
  #    end      
  #  end
  #end

  describe "when username address is already taken" do
    before do
      patient_with_same_username = @patient.dup
      patient_with_same_username.username = @patient.username.upcase
      patient_with_same_username.save
    end

    it { should_not be_valid }
  end
end

