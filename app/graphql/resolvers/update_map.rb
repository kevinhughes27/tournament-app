class Resolvers::UpdateMap < Resolvers::BaseResolver
  def call(inputs, ctx)
    params = inputs.to_h
    params[:edited_at] = Time.now

    if ctx[:tournament].map.update(params)
      {
        success: true,
        message: "Map updated"
      }
    else
      {
        success: false,
        message: "Error updating map"
      }
    end
  end
end
