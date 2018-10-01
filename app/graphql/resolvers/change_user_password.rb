class Resolvers::ChangeUserPassword < Resolvers::BaseResolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @user = @tournament.users.find(inputs[:id])
    @password = inputs[:password]
    @password_confirmation = inputs[:password_confirmation]

    if @password == @password_confirmation
      update_user
    else
       {
        success: false,
        user: @user,
        user_errors: @user.fields_errors
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
        user_errors: "Password does not match Password Confirmation"
      }
    end
   end
end
