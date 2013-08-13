# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  hospital_name   :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  username        :string(255)
#  age             :integer
#  type            :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :username, :age, :first_name, :last_name, :email, :therapist_id, 
              :phone_number, :date_of_birth, :address,
              :hospital_name, :password, :password_confirmation, :type

  has_secure_password

  before_save { |user| user.username = username.downcase } 
  before_save :create_remember_token

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format:     { with: VALID_EMAIL_REGEX }, :allow_nil => true
                    
  validates :username, presence:   true
  
                    
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def full_name
    self.first_name + " " + self.last_name
  end

  def age
    unless self.date_of_birth.nil?
      Date.today.year - self.date_of_birth.year
    end
  end

private

  def create_remember_token
  self.remember_token = SecureRandom.urlsafe_base64
  end

end













