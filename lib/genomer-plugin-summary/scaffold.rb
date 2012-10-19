require 'genomer'
require 'genomer-plugin-summary/metrics'
require 'terminal-table'

class GenomerPluginSummary::Scaffold < Genomer::Plugin
  include GenomerPluginSummary::Metrics

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

  def run
    tabulate calculate_metrics(LAYOUT, scaffold)
  end

  def title
    'Scaffold'
  end

  def tabulate(data)
    table = Terminal::Table.new(:title => title) do |t|
      data.each do |(k,v)|
        t << if k == :separator
               :separator
             else
               v = sprintf('%#.2f',v) if v.class == Float
               [k.ljust(12),v.to_s.rjust(9)]
             end
      end
    end

    table.align_column 0, :left
    table.align_column 1, :right
    table.to_s
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
