# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  accepted_privacy_at    :datetime
#  accepted_terms_at      :datetime
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  preferred_language     :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  time_zone              :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :bigint           not null
#
# Indexes
#
#  index_users_on_account_id            (account_id)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user_one)
  end

  test "should create an user" do
    user = User.new(
      name: "User Three",
      email: "three@procfy.io",
      password: "123456",
      password_confirmation: "123456",
      admin: true,
    )
    assert_equal "User Three", user.name
    assert_equal "three@procfy.io", user.email
    assert user.admin?
    user.name = "User One"
  end

  test "should update an user" do
    @user.update!(
      name: "User Updated",
      admin: false,
    )
    assert_equal "User Updated", @user.name
    assert_not @user.admin?
  end

  test "should find an user by ID" do
    user = User.find(@user.id)
    assert_equal "User One", user.name
    assert_equal "one@procfy.io", user.email
    assert_not user.admin?
  end
end
