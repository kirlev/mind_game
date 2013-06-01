FactoryGirl.define do
  factory :therapist do
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
    age     55
    email    "misha@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
