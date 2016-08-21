get '/' => 'app#show', as: 'app'
post '/submit_score' => 'score_reports#submit', as: 'app_score_submit'
get '/confirm/:id' => 'score_reports#confirm_post', as: 'app_confirm'
post '/confirm/:id' => 'score_reports#confirm_get'
