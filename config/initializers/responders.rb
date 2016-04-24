class ActionController::Responder
  DEFAULT_ACTIONS_FOR_VERBS = {
    :post => :new,
    :patch => :show,
    :put => :show
  }
end
