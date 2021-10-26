require 'test_helper'

class Api::ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com",
                              password: "password", admin: true)

    @article = Article.create(title: "Article title", description: "description", user_id: @admin_user.id)
  end

  test "should get index" do
    get api_articles_url, as: :json
    body = JSON.parse(response.body)
    assert_match body["articles"].first()["title"], @article[:title]
  end

  test "should show article" do
    get '/api/articles/1', as: :json
    body = JSON.parse(response.body)
    assert_match body["title"], @article[:title]
  end

  test "should crete new article" do
    api_token = api_log_in(@admin_user)
    assert_difference('Article.count', 1) do
      post api_articles_url, as: :json, headers: {:Authorization => "Token #{api_token}" }, params: { :title => "Article title2", :description => "description2" }
    end
    body = JSON.parse(response.body)
    assert_match body["message"], "Article was created succesfuly."
  end

  test "should update article" do
    api_token = api_log_in(@admin_user)
    put '/api/articles/1', as: :json, headers: {:Authorization => "Token #{api_token}" }, params: { :title => "Article title2", :description => "description2" }
    body = JSON.parse(response.body)
    assert_match body["message"], "Article was updated succesfuly."
  end

  test "should not update article" do
    api_token = api_log_in(@admin_user)
    put '/api/articles/1', as: :json, headers: {:Authorization => "Token #{api_token}" }, params: { :title => "", :description => "description2" }
    body = JSON.parse(response.body)
    assert_match body["message"], "The following errors prevented the article from beeing saved"
  end

  test "should not update article with invalid token" do
    put '/api/articles/1', as: :json, headers: {:Authorization => "Token 123" }, params: { :title => "Article title2", :description => "description2" }
    assert_response :unauthorized
  end

  test "should delete article" do
    api_token = api_log_in(@admin_user)
    assert_difference('Article.count', -1) do
      delete '/api/articles/1', as: :json, headers: {:Authorization => "Token #{api_token}" }
    end
    assert_response :success
  end

  test "should not delete article" do
    assert_no_difference('Article.count') do
      delete '/api/articles/1', as: :json, headers: {:Authorization => "Token 123" }
    end
    assert_response :unauthorized
  end

end
