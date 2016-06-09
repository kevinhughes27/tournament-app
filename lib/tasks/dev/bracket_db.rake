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

    task :diff => :environment do
      repo = Rugged::Repository.new('.')
      master = repo.branches['master']
      diff = master.target.tree.diff(repo.index)

      bracketDb = YAML.load_file('./db/brackets.yml')

      dbDiff = {}

      diff.each_patch do |patch|
        file = patch.delta.old_file[:path]
        next unless file =~ /db\/brackets\/.*.json/

        template = file.gsub('db/brackets/', '').gsub('.json', '')
        handles = bracketDb.map do |b|
          b['handle'] if b['template'].include?(template)
        end.compact

        handles.each do |handle|
          dbDiff[handle] ||= {}
          dbDiff[handle]['old'] ||= []
          dbDiff[handle]['new'] ||= []

          patch.each_hunk do |hunk|
            hunk.each_line do |line|
              change = begin
                JSON.parse(line.content.strip.gsub(/\,$/, ''))
              rescue
                next
              end

              # this assumes git returns additions and deletions in
              # sequence. aka I see the deletion and then the addition before
              # another change. this seems to be the case
              if line.deletion?
                dbDiff[handle]['old'] << change
              elsif line.addition?
                dbDiff[handle]['new'] << change
              end
            end
          end
        end
      end

      File.open("bracket_db_diff.json","w") do |f|
        f.write(JSON.pretty_generate(dbDiff))
      end
    end
  end
end
