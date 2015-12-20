class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  root 'landing#index'

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  get '/new' => 'signup#new'
  post '/new' => 'signup#create'

  resources :tournaments, controller: 'admin/tournaments', path: '', except: [:show] do
    draw :admin
  end

  get '*tournament_id' => 'app#show'
  post '*tournament_id/submit_score' => 'app#score_submit', as: 'app_score_submit'
end
