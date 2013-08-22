module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
    User.update(user.id, :last_login => DateTime.now) 
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
    session.delete(:return_to)
  end

  def user_path(user)
  	if user.instance_of?(Therapist)    	
      	therapist_path(user)
    elsif user.instance_of?(Patient)
      	patient_path(user)
    else
      therapists_path
    end
  end

  def edit_user_path(user)
    if user.instance_of?(Therapist)     
     edit_therapist_path(user)
    elsif user.instance_of?(Patient)
      edit_patient_path(user)
    else
      root_path
    end
  end

  def user_url(user)
    if user.instance_of?(Therapist)     
        therapist_url(user)
    elsif user.instance_of?(Patient)
        patient_url(user)
    else
      therapists_url
    end
  end

  def edit_user_url(user)
    if user.instance_of?(Therapist)     
     edit_therapist_url(user)
    elsif user.instance_of?(Patient)
      edit_patient_url(user)
    else
      root_url
    end
  end

  def current_user?(user)
    user == current_user
  end

  def current_user_therapist?(user)
    user.therapist_id == current_user.id
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

end
