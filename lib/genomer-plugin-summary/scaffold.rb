require 'genomer'
require 'terminal-table'

class GenomerPluginSummary::Scaffold < Genomer::Plugin

  LAYOUT = [
    {'Contigs (#)'  => :n_contigs},
    {'Gaps (#)'     => :n_gaps},
    :separator,
    {'Size (bp)'    => :bp_size},
    {'Contigs (bp)' => :bp_contigs},
    {'Gaps (bp)'    => :bp_gaps},
    :separator,
    {'G+C (%)'      => :pc_gc},
    {'Contigs (%)'  => :pc_contigs},
    {'Gaps (%)'     => :pc_gaps}
  ]

  def title
    'Scaffold'
  end

  def tabulate(data)
    table = Terminal::Table.new(:title => title) do |t|
      LAYOUT.each do |row|
        t << if row == :separator
               :separator
             else
               key   = row.keys.first
               value = data[row.values.first]
               value = sprintf('%#.2f',value) if value.class == Float
               [key,value.to_s.rjust(9)]
             end
      end
    end

    table.align_column 0, :left
    table.align_column 1, :right

    table.to_s
  end

end
