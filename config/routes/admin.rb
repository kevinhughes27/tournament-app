scope :admin do
  get '/', to: 'admin#index'

  get '/static/*dir/*file', to: 'admin#static'

  get '/*path', to: 'admin#index'
end
