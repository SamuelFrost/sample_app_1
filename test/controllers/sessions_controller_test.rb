require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "new shows log in form and links to sign up and password reset" do
    get new_session_path
    assert_response :success
    assert_select "h1", text: "Log in"
    assert_select "form.auth-form"
    assert_select "a[href=?]", root_path, text: /Back to home/
    assert_select "a[href=?]", new_user_path, text: "Sign up"
    assert_select "a[href=?]", new_password_path, text: "Forgot password?"
  end

  test "create with valid credentials" do
    assert_difference "Session.count", 1 do
      post session_path, params: { email_address: @user.email_address, password: "password" }
    end

    assert_redirected_to root_path
    assert cookies[:session_id].present?

    follow_redirect!
    assert_signed_in_as(@user.email_address)
  end

  test "create with invalid credentials" do
    assert_no_difference "Session.count" do
      post session_path, params: { email_address: @user.email_address, password: "wrong" }
    end

    assert_redirected_to new_session_path
    assert_not cookies[:session_id].present?

    follow_redirect!
    assert_flash_alert "Try another email address or password."
  end

  test "create with unknown email" do
    post session_path, params: { email_address: "missing@example.com", password: "password" }

    assert_redirected_to new_session_path
    follow_redirect!
    assert_flash_alert "Try another email address or password."
  end

  test "destroy signs out and returns to home" do
    sign_in_as(@user)

    delete session_path

    assert_redirected_to root_path
    assert_not cookies[:session_id].present?

    follow_redirect!
    assert_signed_out
  end
end
