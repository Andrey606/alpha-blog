class Api::UsersController < ApiController


  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate, only: [:update, :destroy]
  before_action :requere_same_user, only: [:update, :destroy]

  def index
    # нужно указать ключ :page в запросе чтобы получить нужную страницу с юзерами
    users = User.paginate(page: params[:page], per_page: 50)
    # добавляем переменную в ответ с количеством страниц TOTAL-PAGES
    response.headers['TOTAL-PAGES'] = users.total_pages
    # { users: users }
    render json: { users: users.map {|user| SimpleUserSerializer.new(user)}  }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      key = ApiKey.create(user_id: @user.id)
      render json: { message: "New user created succesfuly", user: SignedInUserSerializer.new(@user, key: key) }
    else
      render json: { message: "The folowing errors prevented the user from beeing saved", messages: @user.errors.full_messages }, status: :unauthorized
    end
  end

  def update
    if @user.update(user_params)
      render json: { message: "User was updated succesfuly.", user: UserSerializer.new(@user) }
    else
      render json: { message: "The folowing errors prevented the user from beeing saved", messages: @user.errors.full_messages }
    end
  end

  def show
    if(@user)
      # render json: { user: @user, articles: @user.articles }
      render json: @user
    else
      # 404 error
      head :not_found
    end
  end

  def destroy
    @user.destroy
    render json: { message: "Account and all associated articles successfuly deleted." }
  end

  private

  def user_params
    params.permit(:username, :email, :password)
  end

  def set_user
    @user = User.find_by_id(params[:id])
  end

  def requere_same_user
    if @current_user != @user && !@current_user.admin?
      render json: { message: "Bad credentials" }, status: :unauthorized
    end
  end

end
