class Resolvers::ChangeUserPassword < Resolvers::BaseResolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @user = @tournament.users.find(inputs[:id])
  
    if @user.update(password: inputs[:password])
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
