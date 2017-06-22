class ActiveSupport::TestCase
  fixtures :all

  # setup do
  #   ReactOnRails::TestHelper.ensure_assets_compiled
  # end

  def stub_constant(mod, const, value)
    original = mod.const_get(const)

    begin
      mod.instance_eval { remove_const(const); const_set(const, value) }
      yield
    ensure
      mod.instance_eval { remove_const(const); const_set(const, original) }
    end
  end

  def response_json
    JSON.parse(@response.body)
  end
end
