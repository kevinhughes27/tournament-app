class Auth::Visibility
  def self.proc(ctx)
    user = ctx[:current_user]
    tournament = ctx[:tournament]

    user && (user.staff? || user.is_tournament_user?(tournament))
  end

  class Filter
    def self.call(schema_member, context)
      return true unless visibility_proc = schema_member.metadata[:visibility_proc]
      visibility_proc.call(context)
    end
  end
end
