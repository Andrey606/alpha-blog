class CategoriesController < ApplicationController

  before_action :set_category, only: [:show]

  def index
  end

  def new
    @category = Category.new
  end

  def show
  end

  def create
    @category = Category.new(name: category_params[:name]) # fors equrity
    if @category.save
      flash[:notice] = "Category was created succesfuly."
      redirect_to category_path(@category) # checck prefix in route
    else
      render 'new'
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
