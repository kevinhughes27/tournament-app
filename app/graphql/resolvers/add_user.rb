class Resolvers::AddUser < Resolvers::BaseResolver
  def call(inputs, ctx)
    @email = inputs[:email]
    @tournament = ctx[:tournament]
    @current_user = ctx[:current_user]

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
    TournamentMailer.add_to_email(@user, @tournament).deliver_later
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
      @user = User.invite!({ email: @email, skip_invitation: true }, @current_user)
      TournamentUser.create!(tournament_id: @tournament.id, user_id: @user.id)
      @user.deliver_invitation
    end
    {
      success: true,
      user: @user,
      message: 'User invited'
    }
  end
end
