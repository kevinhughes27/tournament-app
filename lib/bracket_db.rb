module BracketDb
  def self.root_dir
    File.expand_path('../bracket_db', __FILE__)
  end

  def self.db_path
    File.join(root_dir, 'db')
  end

  def self.brackets_path
    File.join(db_path, 'brackets')
  end
end

require 'frozen_record'
require 'bracket_db/lib/bracket'
