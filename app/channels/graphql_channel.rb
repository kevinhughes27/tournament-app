class GraphqlChannel < ApplicationCable::Channel
  def subscribed
    @subscription_ids = []
  end

  def execute(data)
    query = data["query"]
    variables = data["variables"]
    operation_name = data["operationName"]

    context = {
      tournament: current_tournament,
      tournament_id: current_tournament.id,
      channel: self,
    }

    result = Schema.execute({
      query: query,
      context: context,
      variables: variables,
      operation_name: operation_name
    })

    payload = {
      result: result.subscription? ? { data: nil } : result.to_h,
      more: result.subscription?,
    }

    register_ids(result)
    transmit(payload)
  end

  def register_ids(result)
    if result.context[:subscription_id]
      @subscription_ids << result.context[:subscription_id]
    end
  end

  def unsubscribed
    @subscription_ids.each do |sid|
      Schema.subscriptions.delete_subscription(sid)
    end
  end
end
