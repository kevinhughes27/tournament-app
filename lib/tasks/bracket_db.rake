require_relative '../bracket_db'

namespace :bracket_db do
  desc "checks the json of each bracket individualy"
  task :check do

    Dir.glob('db/brackets/*.json') do |bracket_file|
      bracket_name = bracket_file.gsub('db/brackets/', '').gsub('.json', '')
      bracket_json = BracketDb::load(bracket_name)
      begin
        JSON.parse(bracket_json)
        puts "#{bracket_file} \u2713"
      rescue => e
        puts "#{bracket_file} has invalid json"
      end
    end
  end

  desc "usage: bx rake 'bracket_db:print[usau_8.1]'"
  task :print, [:handle] do |t, args|
    bracket_json = BracketDb::load(args[:handle])
    bracket = JSON.parse(bracket_json)
    puts JSON.pretty_generate(bracket)
  end

  desc "usage: bx rake 'bracket_db:print_tree[usau_8.1]'"
  task :print_tree, [:handle] do |t, args|
    bracket = Bracket.find_by(handle: args[:handle])
    tree = bracket.bracket_tree
    puts JSON.pretty_generate(tree)
  end
end
