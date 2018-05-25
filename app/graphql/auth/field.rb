class Auth::Field < GraphQL::Schema::Field
  # Override #initialize to take a new argument:
  def initialize(*args, auth_required: false, **kwargs, &block)
    @auth_required = auth_required
    # Pass on the default args:
    super(*args, **kwargs, &block)
  end

  def to_graphql
    field_defn = super # Returns a GraphQL::Field

    if @auth_required
      field_defn.metadata[:visibility_proc] = -> (ctx) { visible(ctx) }
    end

    field_defn
  end

  private

  def visible(ctx)
    ctx[:current_user] && ctx[:current_user].is_tournament_user?(ctx[:tournament])
  end
end
