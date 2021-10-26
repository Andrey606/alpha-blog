require 'test_helper'

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com",
                              password: "password", admin: true)
  end

  test "should get index" do
    get api_users_url, as: :json
    body = JSON.parse(response.body)
    assert_match body["users"].first()["username"], @admin_user[:username]
  end

  test "should show user" do
    get '/api/users/1', as: :json
    body = JSON.parse(response.body)
    assert_match body["username"], @admin_user[:username]
  end

  test "should sign up new user" do
    assert_difference('User.count', 1) do
      post api_users_url, as: :json, params: { :username => "Andrew", :email => "andreykuluev96@gmail.com", :password => "1234"}
    end
    body = JSON.parse(response.body)
    assert_match body["message"], "New user created succesfuly"
  end

  test "should not sign up new user" do
    assert_no_difference('User.count') do
      post api_users_url, as: :json, params: { :username => "Andrew", :email => "johndoe@example.com", :password => "1234"}
    end
    body = JSON.parse(response.body)
    assert_match body["message"], "The following errors prevented the user from beeing saved"
  end

  test "should update user" do
    api_token = api_log_in(@admin_user)
    put '/api/users/1', as: :json, headers: {:Authorization => "Token #{api_token}" }, params: { :username => "johndoe_2", :email => "johndoe@example.com", :password => "1234"}
    body = JSON.parse(response.body)
    assert_match body["user"]["username"], "johndoe_2"
  end

  test "should not update user with invalid token" do
    api_token = api_log_in(@admin_user)
    put '/api/users/1', as: :json, headers: {:Authorization => "Token 123" }, params: { :username => "johndoe_2", :email => "johndoe@example.com", :password => "1234"}
    assert_response :unauthorized
  end

  test "should not update user" do
    api_token = api_log_in(@admin_user)
    put '/api/users/1', as: :json, headers: {:Authorization => "Token #{api_token}" }, params: { :username => "", :email => "johndoe@example.com", :password => "1234"}
    body = JSON.parse(response.body)
    assert_match body["message"], "The following errors prevented the user from beeing saved"
  end

  test "should delete user" do
    api_token = api_log_in(@admin_user)
    assert_difference('User.count', -1) do
      delete '/api/users/1', as: :json, headers: {:Authorization => "Token #{api_token}" }
    end
    assert_response :success
  end

end
