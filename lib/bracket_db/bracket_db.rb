require_relative 'structure'

module BracketDb
  @registry = {}

  def self.init
    Dir["#{File.dirname(__FILE__)}/structures/*.rb"].each {|f| require f}
  end

  def self.define(name, &block)
    structure = Structure.new
    structure.instance_eval(&block)
    @registry[name] = structure
  end

  def self.print(name)
    pp @registry[name]
  end
end
