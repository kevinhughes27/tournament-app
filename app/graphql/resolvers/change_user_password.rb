class Resolvers::ChangeUserPassword < Resolvers::BaseResolver
  def call(inputs, ctx)
    @user = ctx[:current_user]
    @password = inputs[:password]
    @password_confirmation = inputs[:password_confirmation]

    if @password == @password_confirmation
      update_user
    else
       {
        success: false,
        user: @user,
        user_errors: [FieldError.new('password', "Passwords don't match")]
      }
    end
  end

  private

  def update_user
    if @user.update(password: @password)
      {
        success: true,
        message: 'Password changed',
        user: @user
      }
    else
      {
        success: false,
        user: @user,
        user_errors: @user.fields_errors
      }
    end
  end
end
