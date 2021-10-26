require 'test_helper'

class Api::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com",
                              password: "password", admin: true)
  end

  test "should log in" do
    token = ""
    assert_difference('ApiKey.count', 1) do
      token = api_log_in(@admin_user)
    end
    body = JSON.parse(response.body)
    assert_match body["user"]["current_key"], token, :success
  end

  test "should log out" do
    token = api_log_in(@admin_user)
    assert_difference('ApiKey.count', -1) do
      delete '/api/logout', as: :json, headers: {:Authorization => "Token #{token}" }
    end
  end
end
