class Auth::Field < GraphQL::Schema::Field
  # Override #initialize to take a new argument:
  def initialize(*args, auth: false, **kwargs, &block)
    @auth = auth
    # Pass on the default args:
    super(*args, **kwargs, &block)
  end

  def to_graphql
    field_defn = super # Returns a GraphQL::Field

    if @auth == :required
      field_defn.metadata[:visibility_proc] = -> (ctx) { Auth::Visibility.proc(ctx) }
    end

    field_defn
  end
end
