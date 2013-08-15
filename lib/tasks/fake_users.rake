namespace :db do 
	desc "Fill database with fake users"
	task populate: :environment do

		Faker::Config.locale = :he
		email = "exampl@braintracker.com"
		password = "foobar"
		admin = User.create!(first_name: "adminstrator", last_name: "adminstrator", email: email,
				username: "admin", password: password, password_confirmation: password)
		admin.toggle!(:admin)

		10.times do |n| 
			first_name = Faker::Name.first_name
			last_name = Faker::Name.last_name
			email = "exampl-#{n+1}@braintracker.com"
			username = "therapist#{n+1}"
			password = "foobar"
			hospital_name = "bet levinstein"
			Therapist.create!(first_name: first_name, last_name: last_name, email: email,
				username: username, password: password, password_confirmation: password,
				hospital_name: hospital_name)
		end

		100.times do |n| 
			first_name = Faker::Name.first_name
			last_name = Faker::Name.last_name
			date_of_birth = Date.today
			phone_number = Faker::PhoneNumber.phone_number
			address = Faker::Address.street_name.to_s + 
						Faker::Address.building_number.to_s + 
						", " + 
						Faker::Address.city.to_s

			email = "exampl-#{n+11}@braintracker.com"
			username = "patient#{n+11}"
			password = "foobar"
			therapist_id = 1 + Random.rand(Therapist.count)
			Patient.create!(first_name: first_name, last_name: last_name, email: email,
				date_of_birth: date_of_birth, phone_number: phone_number, address: address, 
				username: username, password: password, password_confirmation: password,
				therapist_id: therapist_id)
		end

		Game.create(developer: "Nir Levi", name: "Brain Tease")
	end
end
