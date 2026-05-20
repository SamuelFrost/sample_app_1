require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "requires email_address" do
    user = User.new(password: "password", password_confirmation: "password")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "requires unique email_address" do
    user = User.new(
      email_address: users(:one).email_address,
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "requires valid email format" do
    user = User.new(
      email_address: "not-valid",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.valid?
    assert_includes user.errors[:email_address], "is invalid"
  end

  test "authenticates with correct password" do
    assert User.authenticate_by(
      email_address: users(:one).email_address,
      password: "password"
    )
  end

  test "does not authenticate with wrong password" do
    assert_nil User.authenticate_by(
      email_address: users(:one).email_address,
      password: "wrong"
    )
  end
end
