class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  before_action :requere_user, except: [:show, :index]
  before_action :requere_same_user, only: [:edit, :update, :destroy]

  def show
    # byebug
    # @article = Article.find(params[:id]) # '@' - means that it is an instance variable
  end

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def new
    @article = Article.new
  end

  def edit
    # @article = Article.find(params[:id])
  end

  def create
    # render plain: params[:article]
    @article = Article.new(article_params) # fors equrity
    @article.user = current_user
    # render plain: @article.inspect
    if @article.save
      flash[:notice] = "Article was created succesfuly."
      redirect_to article_path(@article) # checck prefix in route
    else
      render 'new'
    end
  end

  def update
    # @article = Article.find(params[:id])

    if @article.update(article_params)
      flash[:notice] = "Article was updated succesfuly."
      redirect_to article_path(@article) # checck prefix in route
    else
      render 'edit'
    end
  end

  def destroy
    # @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])
  end

  def requere_same_user
    if current_user != @article.user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your article"
      redirect_to @article
    end
  end

end
