require 'test_helper'

class Api::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create(name: "Sports")
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com",
                              password: "password", admin: true)
  end

  test "should get index" do
    get api_categories_url, as: :json
    body = JSON.parse(response.body)
    assert_match body["categories"].first()["name"], @category[:name]
  end

  test "should update category" do
    api_token = api_log_in(@admin_user)
    put '/api/categories/1', as: :json, headers: {:Authorization => "Token #{api_token}" }, params: { :name => "Travel" }
    body = JSON.parse(response.body)
    assert_match body["message"], "Category was updated succesfuly."
  end

  test "should not update category" do
    put '/api/categories/1', as: :json, headers: {:Authorization => "Token 123" }, params: { :name => "Travel" }
    body = JSON.parse(response.body)
    assert_match body["message"], "Bad credentials"
  end

  test "should create category" do
    api_token = api_log_in(@admin_user)
    assert_difference('Category.count', 1) do
      post api_categories_url, as: :json, headers: {:Authorization => "Token #{api_token}" }, params: { :name => "Travel" }
    end
    body = JSON.parse(response.body)
    assert_match body["message"], "Category was created succesfuly."
  end
end
