class ActiveSupport::TestCase
  def build_division(tournament, params)
    create = DivisionCreate.new(
      tournament,
      params.merge(name: 'New Division')
    )
    create.perform
    create.division
  end
end
