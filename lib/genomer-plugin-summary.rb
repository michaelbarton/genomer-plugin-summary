require "genomer"

class GenomerPluginSummary < Genomer::Plugin

  def self.fetch(name)
    require 'genomer-plugin-summary/' + name
    const_get(name.capitalize)
  end

  def run
    self.class.fetch(arguments.shift).new(arguments,flags).run
  end

end
