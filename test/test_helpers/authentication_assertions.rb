module AuthenticationAssertions
  def assert_signed_in_as(email_address)
    assert cookies[:session_id].present?, "expected session cookie"
    assert_select ".landing__greeting", text: /#{Regexp.escape(email_address)}/
    assert_select "button", text: "Log out"
  end

  def assert_signed_out
    assert_not cookies[:session_id].present?, "expected no session cookie"
    assert_select "a[href=?]", new_session_path, text: "Log in"
    assert_select "a[href=?]", new_user_path, text: "Sign up"
    assert_select ".landing__cta"
  end

  def assert_flash_notice(text)
    assert_select ".landing__flash--notice", text: /#{text}/
  end

  def assert_flash_alert(text)
    assert_select ".landing__flash--alert", text: /#{text}/
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include AuthenticationAssertions
end
