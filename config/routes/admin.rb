scope :admin do
  get '/', to: 'admin#index', as: 'admin'

  get '/static/*dir/*file', to: 'admin#static'

  get '/*path', to: 'admin#index'
end
