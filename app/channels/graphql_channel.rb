class GraphqlChannel < ApplicationCable::Channel
  def subscribed
    @subscription_ids = []
  end

  def execute(data)
    query = data["query"]
    variables = data["variables"]
    operation_name = data["operationName"]

    # Make sure the channel is in the context
    context = {
      tournament: current_tournament,
      channel: self,
    }

    result = Schema.execute({
      query: query,
      context: context,
      variables: variables,
      operation_name: operation_name
    })

    payload = {
      result: result.subscription? ? nil : result.to_h,
      more: result.subscription?,
    }

    # Track the subscription here so we can remove it
    # on unsubscribe.
    if result.context[:subscription_id]
      @subscription_ids << result.context[:subscription_id]
    end

    transmit(payload)
  end

  def unsubscribed
    @subscription_ids.each do |sid|
      Schema.subscriptions.delete_subscription(sid)
    end
  end
end
