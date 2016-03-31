namespace :dev do
  namespace :bracket_db do
    task :check => :environment do
      require 'bracket'
      Dir.glob('db/brackets/*.json') do |bracket_file|
        bracket_name = bracket_file.gsub('db/brackets/', '').gsub('.json', '')
        bracket_json = load_bracket(bracket_name)
        begin
          JSON.parse(bracket_json)
        rescue => e
          puts "#{bracket_file} has invalid json"
        end
      end
    end
  end
end
