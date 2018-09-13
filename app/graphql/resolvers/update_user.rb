class Resolvers::UpdateUser < Resolvers::BaseResolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @user = @tournament.users.find(inputs[:id])
    params = inputs.to_h.except(:user_id, :confirm)
  
    @user.assign_attributes(params)

    if @user.update(params)
      {
        success: true,
        message: 'User updated',
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
