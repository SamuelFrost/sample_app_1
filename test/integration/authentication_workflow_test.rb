require "test_helper"

class AuthenticationWorkflowTest < ActionDispatch::IntegrationTest
  test "sign up, log out, and log back in" do
    get new_user_path
    assert_response :success
    assert_select "h1", text: "Create your account"
    assert_select "a[href=?]", new_session_path, text: "Log in"

    assert_difference [ "User.count", "Session.count" ], 1 do
      sign_up_as
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_flash_notice "Welcome! Your account has been created."
    assert_signed_in_as("workflow.test@example.com")
    assert_select ".landing__cta", count: 0

    delete session_path
    assert_redirected_to root_path
    follow_redirect!
    assert_signed_out

    get new_session_path
    assert_response :success
    assert_select "h1", text: "Log in"
    assert_select "a[href=?]", new_user_path, text: "Sign up"

    assert_difference "Session.count", 1 do
      post session_path, params: {
        email_address: "workflow.test@example.com",
        password: "securepassword123"
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_signed_in_as("workflow.test@example.com")
    assert_select ".landing__flash--notice", count: 0
  end

  test "sign up normalizes email before displaying greeting" do
    sign_up_as(email_address: "  Workflow.Test@EXAMPLE.COM  ")

    follow_redirect!
    assert_signed_in_as("workflow.test@example.com")
  end

  test "cannot sign up with an email already taken" do
    sign_up_as(email_address: users(:one).email_address, password: "password")

    assert_response :unprocessable_entity
    assert_select "h1", text: "Create your account"
    assert_select ".landing__flash--alert", text: /already been taken/
    assert_not cookies[:session_id].present?
  end

  test "login with wrong password then correct password" do
    sign_up_as
    delete session_path
    follow_redirect!

    post session_path, params: {
      email_address: "workflow.test@example.com",
      password: "wrong-password"
    }

    assert_redirected_to new_session_path
    assert_not cookies[:session_id].present?
    follow_redirect!
    assert_flash_alert "Try another email address or password."

    post session_path, params: {
      email_address: "workflow.test@example.com",
      password: "securepassword123"
    }

    follow_redirect!
    assert_signed_in_as("workflow.test@example.com")
  end
end
