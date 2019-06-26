class Mutations::BaseMutation < GraphQL::Schema::Mutation
  def public?
    false
  end

  def self.public_mutation
    define_method(:public?) { true }
  end

  def resolve(input)
    if public?
      resolver.call(input[:input], context)
    else
      protect(context) { resolver.call(input[:input], context) }
    end
  end

  private

  def resolver
    self.class.to_s.gsub('Mutations::', 'Resolvers::').constantize
  end

  def protect(context)
    if context[:current_user].nil?
      raise GraphQL::ExecutionError.new("You need to sign in or sign up before continuing")
    elsif authorized?(context)
      yield
    else
      raise GraphQL::ExecutionError.new("You are not a registered user for this tournament")
    end
  end

  def authorized?(inputs)
    user = context[:current_user]
    tournament = context[:tournament]

    user.staff? || user.is_tournament_user?(tournament)
  end
end
