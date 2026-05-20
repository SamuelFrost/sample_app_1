require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "new shows sign up form and link to log in" do
    get new_user_url
    assert_response :success
    assert_select "h1", text: "Create your account"
    assert_select "form.auth-form"
    assert_select "input[name='user[email_address]']"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']"
    assert_select "a[href=?]", root_path, text: /Back to home/
    assert_select "a[href=?]", new_session_path, text: "Log in"
  end

  test "create signs in and redirects home with welcome notice" do
    assert_difference [ "User.count", "Session.count" ], 1 do
      sign_up_as(email_address: "new@example.com", password: "password")
    end

    assert_redirected_to root_url
    assert cookies[:session_id].present?

    follow_redirect!
    assert_flash_notice "Welcome! Your account has been created."
    assert_signed_in_as("new@example.com")
  end

  test "create does not sign in when validation fails" do
    assert_no_difference [ "User.count", "Session.count" ] do
      post users_url, params: {
        user: {
          email_address: "",
          password: "password",
          password_confirmation: "mismatch"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select ".landing__flash--alert li", minimum: 1
    assert_not cookies[:session_id].present?
  end

  test "create rejects duplicate email" do
    assert_no_difference "User.count" do
      sign_up_as(email_address: users(:one).email_address, password: "password")
    end

    assert_response :unprocessable_entity
    assert_select ".landing__flash--alert", text: /already been taken/
  end

  test "create rejects invalid email format" do
    assert_no_difference "User.count" do
      sign_up_as(email_address: "not-an-email", password: "password")
    end

    assert_response :unprocessable_entity
    assert_select ".landing__flash--alert", text: /invalid/i
  end
end
