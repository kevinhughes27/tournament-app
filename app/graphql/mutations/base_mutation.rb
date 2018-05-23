class Mutations::BaseMutation < GraphQL::Schema::Mutation
  def resolve(input)
    resolver = self.class.to_s.gsub('Mutations::', 'Resolvers::').constantize
    Auth.protect(context) { resolver.call(input[:input], context) }
  end
end
