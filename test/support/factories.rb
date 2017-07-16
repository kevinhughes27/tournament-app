class ActiveSupport::TestCase
  def create_division(params)
    create = DivisionCreate.new(
      @tournament,
      params.merge(name: 'New Division')
    )
    create.perform
    create.division
  end
end
