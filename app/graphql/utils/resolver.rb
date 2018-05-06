class Resolver
  def self.call(_, inputs, ctx)
    self.new.call(inputs, ctx)
  end
end
