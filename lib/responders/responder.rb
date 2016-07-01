class ActionController::Responder
  ACTIONS_FOR_VERBS = {
    post: :new,
    patch: :show,
    put: :show
  }

  def default_action
    @action ||= ACTIONS_FOR_VERBS[request.request_method_symbol]
  end
end
