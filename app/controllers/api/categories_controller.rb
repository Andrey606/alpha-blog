class Api::CategoriesController < ApiController
  before_action :authenticate, only: [:update, :create]
  before_action :set_category, only: [:update]
  before_action :require_admin, except: [:index]

  def update
    if @category.update(category_params)
      render json: { message: "Category was updated succesfuly.", user: CategorySerializer.new(@category) }
    else
      render json: { message: "The folowing errors prevented the category from beeing saved", messages: @category.errors.full_messages }
    end
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: { message: "Category was created succesfuly.", category: CategorySerializer.new(category) }
    else
      render json: { message: "The folowing errors prevented the category from beeing saved", messages: category.errors.full_messages }
    end
  end

  def index
    categories = Category.all
    render json: { categories: categories.map {|category| CategorySerializer.new(category)} }
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !(@current_user.admin?)
      render json: { message: "Only admins can perform that action" }, status: :unauthorized
    end
  end
end
