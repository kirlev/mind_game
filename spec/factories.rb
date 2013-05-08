FactoryGirl.define do
  factory :therapist do
    first_name     "Michael"
    last_name     "Hartl"
    hospital_name     "blabla"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
