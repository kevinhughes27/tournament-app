class Admin::AccountController < AdminController

  def show
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_attributes(user_params)
      flash.now[:notice] = 'Account updated.'
    else
      flash.now[:alert] = 'Error updating Account.'
    end

    render :show
  end

  private

  def user_params
    @user_params = params.require(:user).permit(
      :email,
      :password,
      :password_confirmation
    )

    @user_params.delete(:password) if @user_params[:password].blank?
    @user_params.delete(:password_confirmation) if @user_params[:password_confirmation].blank?
    @user_params
  end
end
