namespace :dev do
  namespace :bracket_db do
    task :check => :environment do
      require 'bracket'

      Dir.glob('db/brackets/*.json') do |bracket_file|
        bracket_name = bracket_file.gsub('db/brackets/', '').gsub('.json', '')
        bracket_json = BracketDb::load(bracket_name)
        begin
          JSON.parse(bracket_json)
        rescue => e
          puts "#{bracket_file} has invalid json"
        end
      end
    end

    task :print, [:handle] => [:environment] do |t, args|
      desc "usage: bx rake 'dev:bracket_db:print[usau_8.1]'"
      require 'bracket'

      bracket_json = BracketDb::load(args[:handle])
      bracket = JSON.parse(bracket_json)
      puts JSON.pretty_generate(bracket)
    end

    task :diff => :environment do
      repo = Rugged::Repository.new('.')
      master = repo.branches['master']
      diff = master.target.tree.diff(repo.index)

      diff.each_patch do |patch|
        process_patch(patch)
      end

      File.open("db/bracket_db_diff.json","w") do |f|
        f.write(JSON.pretty_generate(dbDiff))
      end
    end
  end
end

def process_patch(patch)
  file = patch.delta.old_file[:path]
  return unless is_bracket_db_file?(file)

  handles = handles_for_file(file)

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

def is_bracket_db_file?(file)
  is_bracket_db_partial?(file) ||
  is_bracket_db_template?(file)
end

def is_bracket_db_template?(file)
  file =~ /db\/brackets\/.*.json/
end

def is_bracket_db_partial?(file)
  file =~ /db\/brackets\/partials\/.*.json/
end

def handles_for_file(file)
  if is_bracket_db_partial?(file)
    handles_for_partial(file)
  elsif is_bracket_db_template?(file)
    handles_for_template
  end
end

def handles_for_partial(file)
  partial = partial_name_from_file_name(file)
  brackets = rawBracketDb.select do |bracket|
    templateName = template_name_from_bracket_template(bracket['template'])
    rawTemplate = loadRawTemplate(templateName)
    rawTemplate.include? partial
  end

  brackets.map do |b|
    b['handle']
  end
end

def template_name_from_bracket_template(bracket_template)
  bracket_template
    .gsub("<%= load('", '')
    .gsub("') %>", '')
end

def partial_name_from_file_name(file)
  file.gsub('db/brackets/partials/', '').gsub('.json', '')
end

def handles_for_template
  templateName = template_name_from_file_name(file)

  rawBracketDb.map do |b|
    b['handle'] if b['template'].include? templateName
  end.compact
end

def template_name_from_file_name(file)
  file.gsub('db/brackets/', '').gsub('.json', '')
end

def rawBracketDb
  @rawBracketDb ||= YAML.load_file('./db/brackets.yml')
end

def loadRawTemplate(template)
  File.read("./db/brackets/#{template}.json")
end

def dbDiff
  @dbDiff ||= {}
end
