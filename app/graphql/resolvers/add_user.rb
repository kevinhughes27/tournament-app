class Resolvers::AddUser < Resolvers::BaseResolver
  def call(inputs, ctx)
    @email = inputs[:email]
    @tournament = ctx[:tournament]

    if user_exists?
      add_user
    else
      invite_user
    end
  end

  private

  def user_exists?
    @user = User.find_by(email: @email)
  end

  def add_user
    TournamentUser.create!(tournament_id: @tournament.id, user_id: @user.id)
    # send an email letting them know about the new tournament they have access too.
    {
      success: true,
      user: @user,
      message: 'User added'
    }
  rescue ActiveRecord::RecordInvalid => e
    {
      success: true,
      user: @user,
      message: 'User already added'
    }
  end

  def invite_user
    User.transaction do
      @user = User.invite!(email: @email)
      TournamentUser.create!(tournament_id: @tournament.id, user_id: @user.id)
    end
    # email sent. what are the contents? does it make sense.
    {
      success: true,
      user: @user,
      message: 'User invited'
    }
  end
end
