require_relative 'structure'

module BracketDb
  @registry = {}

  def self.define(name, &block)
    structure = Structure.new
    structure.instance_eval(&block)
    @registry[name] = structure
  end

  def self.print(name)
    pp @registry[name]
  end
end
