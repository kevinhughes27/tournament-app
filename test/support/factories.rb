class ActiveSupport::TestCase
  def create_division(params)
    if self.singleton_class.include? ActiveJob::TestHelper
      perform_enqueued_jobs { _create_division(params) }
    else
      _create_division(params)
    end
  end

  def _create_division(params)
    create = DivisionCreate.new(
      @tournament,
      params.merge(name: 'New Division')
    )
    create.perform
    create.division
  end
end
