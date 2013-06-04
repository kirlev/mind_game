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
