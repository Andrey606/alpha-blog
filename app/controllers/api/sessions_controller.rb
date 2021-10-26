class Api::SessionsController < ApiController

  before_action :authenticate, only: [:destroy]

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      key = ApiKey.create(user_id: user.id)
      render json: { message: "Loged in succesfuly", user: SignedInUserSerializer.new(user, key: key) }
    else
      render json: { message: "There was something wrong with your login details." }, status: :unauthorized
    end
  end

  def destroy
    @token.destroy
    render json: { message: "Logged out" }
  end

  private

  def session_params
    params.require(:session).permit(:username, :email, :password)
  end

end
