class Api::UsersController < ApiController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :requere_user, only: [:edit, :update]
  before_action :requere_same_user, only: [:edit, :update, :destroy]

  def index
    # нужно указать ключ :page в запросе чтобы получить нужную страницу с юзерами
    users = User.paginate(page: params[:page], per_page: 5)
    # добавляем переменную в ответ с количеством страниц TOTAL-PAGES
    response.headers['TOTAL-PAGES'] = users.total_pages
    render json: { users: users }
  end

  def new
    # TODO:
  end

  def create
    # TODO:
  end

  def edit
    # TODO:
  end

  def update
    # TODO:
  end

  def show
    if(@user)
      @user.articles
      render json: @user
    else
      # 404 error
      head :not_found
    end
  end

  def destroy
    # TODO:
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def requere_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only edit or delete your own account"
      redirect_to @user
    end
  end
end
