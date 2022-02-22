# メインのサンプルユーザを1人作成する
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザをまとめて生成する
99.times do |n|
  name = Faker::Name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email: email,
               password:  password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end