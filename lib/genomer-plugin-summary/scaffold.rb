require 'genomer'
require 'genomer-plugin-summary/metrics'
require 'genomer-plugin-summary/format'

class GenomerPluginSummary::Scaffold < Genomer::Plugin
  include GenomerPluginSummary::Metrics
  include GenomerPluginSummary::Format

  LAYOUT = [
    {:name => 'Contigs (#)',  :entry_type => :sequence,   :method => :count},
    {:name => 'Gaps (#)',     :entry_type => :unresolved, :method => :count},
    :separator,
    {:name => 'Size (bp)',    :entry_type => :all,        :method => :length},
    {:name => 'Contigs (bp)', :entry_type => :sequence,   :method => :length},
    {:name => 'Gaps (bp)',    :entry_type => :unresolved, :method => :length},
    :separator,
    {:name => 'G+C (%)',      :entry_type => :all,        :method => :gc_content},
    {:name => 'Contigs (%)',  :entry_type => :sequence,   :method => :percent},
    {:name => 'Gaps (%)',     :entry_type => :unresolved, :method => :percent}
  ]

  FORMATTING = {
    :title         => 'Scaffold',
    :width         => {0 => 12, 1 => 9},
    :justification => {1 => :right},
    :format        => {1 => lambda{|i| i.class == Float ? sprintf('%#.2f',i) : i }}
  }

  def run
    tabulate(calculate_metrics(LAYOUT, scaffold),flags)
  end

  def tabulate(data,flags)
    FORMATTING.store(:output,flags[:output]) if flags[:output]
    table(data,FORMATTING)
  end

  def calculate_metrics(specs,scaffold)
    specs.map do |spec|
      if spec == :separator
        spec
      else
        [spec[:name], send(spec[:method],spec[:entry_type],scaffold)]
      end
    end
  end

end
