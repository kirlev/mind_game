FactoryGirl.define do
  factory :therapist do
    username   "michaelhartl"
    first_name     "Michael"
    last_name     "Hartl"
    hospital_name     "blabla"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end

  factory :patient do
  	username     "mishaKatz"
    first_name     "Misha"
    last_name     "Katz"
    age     Date.new(1950, 5, 12)
    password "foobar"
    password_confirmation "foobar"
  end

  factory :user do
    username     "kirlev"
    first_name     "Kir"
    last_name     "Lev"
    password "foobar"
    password_confirmation "foobar"
  end
end
