require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "index redirects unauthenticated users to login" do
    get root_path
    assert_redirected_to new_session_path
  end

  test "index shows signed-in user" do
    sign_in_as(User.take)

    get root_path

    assert_response :success
    assert_select "p", text: /Signed in as #{User.take.email_address}/
  end
end
