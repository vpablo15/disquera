# frozen_string_literal: true

COMMON_PASSWORD = '123456'
ADMIN_EMAIL = 'admin@admin'
MANAGER_EMAIL = 'manager@manager'
NUM_TEST_USERS = 10


admin_user = User.find_or_create_by!(email: ADMIN_EMAIL) do |user|
  user.password = COMMON_PASSWORD
  user.password_confirmation = COMMON_PASSWORD
  user.role = User.roles[:admin]
end

manager_user = User.find_or_create_by!(email: MANAGER_EMAIL) do |user|
  user.password = COMMON_PASSWORD
  user.password_confirmation = COMMON_PASSWORD
  user.role = User.roles[:manager]
end

employee = User.find_or_create_by!(email: 'employee@employee') do |user|
  user.password = COMMON_PASSWORD
  user.password_confirmation = COMMON_PASSWORD
  user.role = User.roles[:employee]
end

names = %w[lautaro pablo tomas]
names.each do |i|
  email = "#{i}@#{i}"
  User.find_or_create_by!(email: email) do |user|
    user.password = COMMON_PASSWORD
    user.password_confirmation = COMMON_PASSWORD
    user.role = User.roles[:employee]
  end
end

# NUM_TEST_USERS.times do |i|
#   email = "test_user_#{i + 1}@prueba.com"
#   User.find_or_create_by!(email: email) do |user|
#     user.password = COMMON_PASSWORD
#     user.password_confirmation = COMMON_PASSWORD
#   end
# end