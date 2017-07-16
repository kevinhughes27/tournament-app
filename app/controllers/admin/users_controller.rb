class Admin::UsersController < AdminController
  def index
    @users = @tournament.users
  end

  def new
    @user = User.new
  end

  def create
    Tournament.transaction do
      user = User.create!(user_params)
      TournamentUser.create!(tournament: @tournament, user: user)
    end

    flash[:notice] = 'User was successfully created.'
    redirect_to admin_users_path
  rescue StandardError => e
    flash[:error] = 'Error creating user.'
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
