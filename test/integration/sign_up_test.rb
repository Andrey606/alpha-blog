require "test_helper"

class SignUpTest < ActionDispatch::IntegrationTest

  test "sign up user if data are correct" do
    @user = { username: "johndoe", email: "johndoe@example.com", password: "password", admin: true }

    get "/signup"
    assert_response :success
    assert_difference 'User.count', 1 do
      post users_path, params: { user: @user }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match @user[:username], response.body
  end

  test "don't sign up user if data are not correct" do
    @user = { username: "", email: "johndoe@example.com", password: "password", admin: true }

    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: @user }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

  test "don't sign up user if alredy exsist" do
    User.create(username: "johndoe", email: "johndoe@example.com", password: "password", admin: false)
    @user = { username: "johndoe", email: "johndoe@example.com", password: "password", admin: false }

    get "/signup"
    assert_response :success
    assert_no_difference 'User.count' do
      post users_path, params: { user: @user }
    end
    assert_match "errors", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

end
