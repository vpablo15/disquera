# frozen_string_literal: true

COMMON_PASSWORD = '123456'
ADMIN_EMAIL = 'admin@admin.com'
NUM_TEST_USERS = 10


admin_user = User.find_or_create_by!(email: ADMIN_EMAIL) do |user|
  user.password = COMMON_PASSWORD
  user.password_confirmation = COMMON_PASSWORD
end

NUM_TEST_USERS.times do |i|
  email = "test_user_#{i + 1}@prueba.com"
  User.find_or_create_by!(email: email) do |user|
    user.password = COMMON_PASSWORD
    user.password_confirmation = COMMON_PASSWORD
  end
end