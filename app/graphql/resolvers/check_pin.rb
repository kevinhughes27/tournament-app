class Resolvers::CheckPin < Resolvers::BaseResolver
  def call(inputs, ctx)
    valid = (inputs[:pin] == ctx[:tournament].score_submit_pin)

    if valid
      { success: true }
    else
      { success: false }
    end
  end
end
