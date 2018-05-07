scope :admin_next do
  get '/', to: 'admin_next#index'

  get '/static/*dir/*file', to: 'admin_next#static'

  get '/*path', to: 'admin_next#index'
end
