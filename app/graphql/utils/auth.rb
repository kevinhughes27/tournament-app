module Auth
  def self.visible(ctx)
    ctx[:current_user] && ctx[:current_user].is_tournament_user?(ctx[:tournament])
  end

  def self.protect(context)
    if context[:current_user].nil?
      raise GraphQL::ExecutionError.new("You need to sign in or sign up before continuing")
    elsif context[:current_user].is_tournament_user?(context[:tournament])
      yield
    else
      raise GraphQL::ExecutionError.new("You are not a registered user for this tournament")
    end
  end
end
