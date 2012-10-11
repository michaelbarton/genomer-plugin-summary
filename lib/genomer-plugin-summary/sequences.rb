require 'genomer'
require 'terminal-table'

class GenomerPluginSummary::Sequences < Genomer::Plugin

  def run
    sequences = calculate(scaffold)
    total     = total(sequences)

    tabulate(sequences,total)
  end

  def headings
    ['Sequence'.left(12),
     'Start (bp)'.center(10),
     'End (bp)'.center(10),
     'Size (bp)'.center(10),
     'Size (%)'.center(8),
     'GC (%)'.center(6)]
  end

  def title
    'Scaffold Sequences'
  end

  def tabulate(rows,total)
    table = Terminal::Table.new(:title => title) do |t|
      t << headings
      t << :separator
      rows.each do |row|
        t << table_array(row)
      end
      t << :separator
      t << table_array(total.merge({:sequence => 'Scaffold'}))
    end

    table.align_column 0, :left
    table.align_column 1, :right
    table.align_column 2, :right
    table.align_column 3, :right
    table.align_column 4, :right
    table.align_column 5, :right

    table.to_s
  end

  def table_array(hash)
    [:sequence,:start,:end,:size,:percent,:gc].map{|i| hash[i]}
  end

  def calculate(scaffold)
    []
  end

  def total(sequences)
    {:start   => 'NA',
     :end     => 'NA',
     :size    => 'NA',
     :percent => 'NA',
     :gc      => 'NA' }
  end

end
