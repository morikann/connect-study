AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

100.times do |n|
  email = "example#{n+1}@example.com"
  password = "password"
  user = User.create!(
    email: email,
    password: password,
    password_confirmation: password,
  )
  user.create_profile(
    username: "ユーザー",
    purpose: "頑張るぞ",
    prefecture_id: 5,
    self_introduction: "日々精進",
    "birth_date(1i)"=>"1995",
    "birth_date(2i)"=>"6",
    "birth_date(3i)"=>"3",
    tag: 'プログラミング'
  )
end