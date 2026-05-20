require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user and sign in" do
    assert_difference("User.count") do
      post users_url, params: {
        user: {
          email_address: "new@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to root_url
    follow_redirect!
    assert_response :success
    assert_match "new@example.com", response.body
  end

  test "should not create user with invalid data" do
    assert_no_difference("User.count") do
      post users_url, params: {
        user: {
          email_address: "",
          password: "password",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
