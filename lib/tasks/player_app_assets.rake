namespace :player_app do
  namespace :assets do
    task :build do
      `cd player-app && yarn run build`
    end
  end
end

Rake::Task["assets:precompile"]
  .enhance([:environment, "player_app:assets:build"])
