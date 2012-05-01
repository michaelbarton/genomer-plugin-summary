require 'genomer'
require 'terminal-table'

class GenomerPluginSummary::Gaps < Genomer::Plugin

  def headings
    ['Number'.center(8),
     'Length'.center(8),
     'Start'.center(8),
     'End'.center(8),
     'Type'.center(12)]
  end

  def title
    'Scaffold Gaps'
  end

  def tabulate(contigs)
    table = Terminal::Table.new(:title => title) do |t|
      t << headings
      t << :separator
      contigs.each do |ctg|
        t << [ctg[:number],
              ctg[:length],
              ctg[:start],
              ctg[:end],
              ctg[:type]]
      end
    end

    table.style = {:width => 60}
    table.align_column 0, :right
    table.align_column 1, :right
    table.align_column 2, :right
    table.align_column 3, :right
    table.align_column 4, :center

    table
  end

end
