# == Schema Information
#
# Table name: therapists
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  hospital_name   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Therapist do

  before { @therapist = Therapist.new(first_name: "Example", last_name: "Therapist", hospital_name: "levinstein",
                         email: "Therapist@example.com", password: "foobar", password_confirmation: "foobar") }

  subject { @therapist }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }  
  it { should respond_to(:hospital_name) }
  it { should respond_to(:password_digest) }  
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when first name is not present" do
    before { @therapist.first_name = " " }
    it { should_not be_valid }
  end
  describe "when last name is not present" do
    before { @therapist.last_name = " " }
    it { should_not be_valid }
  end
  describe "when email is not present" do
    before { @therapist.email = " " }
    it { should_not be_valid }
  end
  describe "when hospital name is not present" do
    before { @therapist.hospital_name = " " }
    it { should_not be_valid }
  end
  describe "when password is not present" do
    before { @therapist.password = @therapist.password_confirmation = " " }
    it { should_not be_valid }
  end
  describe "when password doesn't match confirmation" do
    before { @therapist.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  describe "when password confirmation is nil" do
    before { @therapist.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @therapist.save }
    let(:found_therapist) { Therapist.find_by_email(@therapist.email) }

    describe "with valid password" do
      it { should == found_therapist.authenticate(@therapist.password) }
    end

    describe "with invalid password" do
      let(:therapist_for_invalid_password) { found_therapist.authenticate("invalid") }

      it { should_not == therapist_for_invalid_password }
      specify { therapist_for_invalid_password.should be_false }
    end
  end


  describe "when first name is too long" do
    before { @therapist.first_name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when last name is too long" do
    before { @therapist.last_name = "b" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[therapist@foo,com therapist_at_foo.org example.therapist@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @therapist.email = invalid_address
        @therapist.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @therapist.email = valid_address
        @therapist.should be_valid
      end      
    end
  end

  describe "when email address is already taken" do
    before do
      therapist_with_same_email = @therapist.dup
      therapist_with_same_email.email = @therapist.email.upcase
      therapist_with_same_email.save
    end

    it { should_not be_valid }
  end
end
