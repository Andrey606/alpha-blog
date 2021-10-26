class Api::ArticlesController < ApiController
  before_action :authenticate, only: [:update, :destroy, :create]
  before_action :set_article, only: [:show, :update, :destroy]
  before_action :requere_same_user, only: [:update, :destroy]

  def index
    articles = Article.paginate(page: params[:page], per_page: 50)
    response.headers['TOTAL-ARTICLES'] = articles.total_pages
    render json: { articles: articles.map {|article| ArticleSerializer.new(article)}  }
  end

  def show
    render json: @article
  end

  def create
    @article = Article.new(article_params) # fors equrity
    @article.user = @current_user
    if @article.save
      render json: { message: "Article was created succesfuly.", user: ArticleSerializer.new(@article) }
    else
      render json: { message: "The folowing errors prevented the article from beeing saved", messages: @article.errors.full_messages }
    end
  end

  def update
    if @article.update(article_params)
      render json: { message: "Article was updated succesfuly.", user: ArticleSerializer.new(@article) }
    else
      render json: { message: "The folowing errors prevented the article from beeing saved", messages: @article.errors.full_messages }
    end
  end

  def destroy
    @article.destroy
    render json: { message: "Article successfuly deleted." }
  end

  private

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def set_article
    @article = Article.find_by_id(params[:id])
  end

  def requere_same_user
    if @current_user != @article.user && !@current_user.admin?
      render json: { message: "Bad credentials" }, status: :unauthorized
    end
  end

end
