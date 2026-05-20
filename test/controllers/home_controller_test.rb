require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "guest sees sign up and log in navigation" do
    get root_url
    assert_response :success
    assert_select "h1.landing__title"
    assert_select "[data-controller='landing']"
    assert_select "[data-landing-phrases-value]"
    assert_signed_out
  end

  test "signed in user sees greeting and no guest call to action" do
    sign_in_as(users(:one))

    get root_url
    assert_response :success
    assert_signed_in_as(users(:one).email_address)
    assert_select ".landing__cta", count: 0
    assert_select "a[href=?]", new_user_path, text: "Sign up", count: 0
  end

end
