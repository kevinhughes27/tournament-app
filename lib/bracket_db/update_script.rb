require 'yaml'
require 'byebug'

bracket_db = YAML.load(File.read('legacy/brackets.yml'))

bracket_db.each do |bracket|
  template_name = bracket['template']
    .gsub("<%= BracketDb::load('", '')
    .gsub("') %>", '')

  template = File.read("legacy/brackets/#{template_name}.json")

  name = bracket['handle'].upcase
    .gsub(' ', '_')

  ruby_file_name = name.downcase + '.rb'

  ## sort of update the templaye to the dsl

  new_template = template
    .gsub("<%= BracketDb::table_partial('table_", "pool '")
    .gsub(", pool: ", "")
    .gsub("seeds: ", "")
    .gsub("<%= BracketDb::partial('bracket_", "bracket '")
    .gsub(") %>,", "")

  ## Build new ruby file

  ruby_file = ""
  ruby_file += "BracketDb.define '#{name}' do\n"
  ruby_file += "  name '#{bracket['name']}'\n"
  ruby_file += "  description '#{bracket['description']}'\n" if bracket['description']
  ruby_file += "  teams '#{bracket['num_teams']}'\n"
  ruby_file += "  days '#{bracket['days']}'\n"
  ruby_file += "\n\n"
  ruby_file += new_template
  ruby_file += "\n\n"
  ruby_file += "end\n"

  ## Save new ruby file
  File.write("structures/#{ruby_file_name}", ruby_file)
end
