module SignUpTestHelper
  SIGN_UP_PARAMS = {
    email_address: "workflow.test@example.com",
    password: "securepassword123",
    password_confirmation: "securepassword123"
  }.freeze

  def sign_up_params(overrides = {})
    { user: SIGN_UP_PARAMS.merge(overrides) }
  end

  def sign_up_as(email_address: SIGN_UP_PARAMS[:email_address], password: SIGN_UP_PARAMS[:password])
    post users_path, params: sign_up_params(
      email_address: email_address,
      password: password,
      password_confirmation: password
    )
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  include SignUpTestHelper
end
