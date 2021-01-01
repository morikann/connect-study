# 99.times do |n|
#   email = "example#{n+1}@example.com"
#   password = "password"
#   User.create!(
#     email: email,
#     password: password,
#     password_confirmation: password,
#   )
# end

# User.all.each do |user|
#   user.create_profile!(
#     username: "ユーザー",
#     purpose: "頑張るぞ",
#     prefecture_id: 5,
#     self_introduction: "日々精進",
#     "birth_date(1i)"=>"1995",
#     "birth_date(2i)"=>"6",
#     "birth_date(3i)"=>"3",
#   )
# end

admin_user = User.create(
  email: 'admin@admin.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true
)

admin_user.create_profile!(
  username: '管理ユーザー',
  purpose: '良いサービスをつくる',
  prefecture_id: 10,
  self_introduction: 'connectを作りました',
  "birth_date(1i)"=>"2000",
  "birth_date(2i)"=>"8",
  "birth_date(3i)"=>"8",
  tag: 'プログラミング'
)
