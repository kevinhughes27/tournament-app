class Auth::Visibility
  def self.proc(ctx)
    ctx[:current_user] && ctx[:current_user].is_tournament_user?(ctx[:tournament])
  end

  class Filter
    def self.call(schema_member, context)
      return true unless visibility_proc = schema_member.metadata[:visibility_proc]
      visibility_proc.call(context)
    end
  end
end
