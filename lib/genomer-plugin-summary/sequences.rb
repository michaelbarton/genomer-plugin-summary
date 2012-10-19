require 'genomer'
require 'genomer-plugin-summary/metrics'
require 'terminal-table'

class GenomerPluginSummary::Sequences < Genomer::Plugin
  include GenomerPluginSummary::Metrics

  def run
    sequences = calculate(scaffold)
    total     = total(sequences)

    tabulate(sequences,total)
  end

  def headings
    ['Sequence'.left(16),
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
      t << table_array(total.merge({:sequence => 'All'}))
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
    [:sequence,:start,:end,:size,:percent,:gc].
      map{|i| hash[i]}.
      map{|i| i.class == Float ? sprintf('%#.2f',i) : i }
  end

  def calculate(scaffold)
    total_length   = length(:all,scaffold).to_f
    running_length = 0

    scaffold.map do |entry|
      i = nil
      if entry.entry_type != :unresolved
        entry_length = entry.sequence.length
        i = { :sequence => entry.source,
              :start    => running_length + 1,
              :end      => running_length + entry_length,
              :size     => entry_length,
              :percent  => entry_length / total_length * 100,
              :gc       => gc(entry) / atgc(entry) * 100 }
      end
        
      running_length += entry.sequence.length
      i
    end.compact
  end

  def total(seqs)
    return Hash[[:start, :end, :size, :percent, :gc].map{|i| [i, 'NA']}] if seqs.empty?

    totals = seqs.inject({:size => 0, :percent => 0, :gc => 0}) do |hash,entry|
      hash[:start]  ||= entry[:start]
      hash[:end]      = entry[:end]
      hash[:size]    += entry[:size]
      hash[:percent] += entry[:percent]
      hash[:gc]      += entry[:gc] * entry[:size]

      hash
    end
    totals[:gc] /= totals[:size]
    totals
  end

end
