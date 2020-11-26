module ProfilesHelper
  def user_age(user_birth_date)
    today = Date.today.strftime("%Y%m%d").to_i
    birthday = user_birth_date.strftime("%Y%m%d").to_i
    age = ( today - birthday) / 10000 
    return age
  end

  def current_user?(user)
    current_user == user
  end
end
