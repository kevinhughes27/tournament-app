module Auth
  def self.visible(ctx)
    ctx[:current_user] && ctx[:current_user].is_tournament_user?(ctx[:tournament])
  end

  def self.protect(resolve)
    -> (obj, args, ctx) do
      if ctx[:current_user].nil?
        FieldError.error("You need to sign in or sign up before continuing")
      elsif ctx[:current_user].is_tournament_user?(ctx[:tournament])
        resolve.call(obj, args, ctx)
      else
        FieldError.error("You are not a registered user for this tournament")
      end
    end
  end
end
