def full_title(page_title)
		base_title = "Brain Tracker"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def user_path(user)
  	if user.instance_of?(Therapist)    	
      	therapist_path(user)
    elsif user.instance_of?(Patient)
      	patient_path(user)
    end
end

def sign_in(user)
  visit signin_path
  fill_in "Username",    with: user.username.upcase
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end
