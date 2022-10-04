

10.times do
  firstname = Faker::Name.first_name
  lastname = Faker::Name.last_name
  password = "Password1"

  User.create!({
    email: "#{firstname}.#{lastname}@example.com",
    password: password,
    password_confirmation: password
  })
end