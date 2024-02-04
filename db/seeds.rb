if Rails.env.development?
  User.create!(email: 'superadmin@gmail.com', password: 'password', role: :superadmin)
  5.times.with_index {|i| User.create!(email: "admin#{i}@gmail.com", password: 'password', role: :admin) }
end
