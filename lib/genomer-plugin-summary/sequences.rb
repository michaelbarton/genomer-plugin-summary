require 'genomer'
require 'terminal-table'

class GenomerPluginSummary::Sequences < Genomer::Plugin

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
    [:sequence,:start,:end,:size,:percent,:gc].
      map{|i| hash[i]}.
      map{|i| i.class == Float ? sprintf('%#.2f',i) : i }
  end

  def calculate(scaffold)
    length = 0
    total_length = scaffold.map(&:sequence).join.length.to_f
    scaffold.reject{|i| i.entry_type == :unresolved}.map do |entry|

      entry_length = entry.sequence.length
      i = { :sequence => entry.source,
            :start    => length + 1, 
            :end      => length + entry_length,
            :size     => entry_length,
            :percent  => entry_length / total_length * 100,
            :gc       => gc_content(entry.sequence) }
      length += entry.sequence.length
      i
    end
  end

  def total(seqs)
    return Hash[[:start, :end, :size, :percent, :gc].map{|i| [i, 'NA']}] if seqs.empty?

    totals = seqs.inject({:size => 0, :percent => 0, :gc => 0}) do |hash,entry|
      hash[:start]  ||= entry[:start]
      hash[:end]      = entry[:end]
      hash[:size]    += entry[:size]
      hash[:percent] += entry[:percent]
      hash[:gc]      += entry[:percent] / 100 * entry[:gc]

      hash
    end
  end

  def gc_content(sequence)
    nucleotides = sequence.gsub(/[^ATGCatgc]/,'')
    nucleotides.gsub(/[^GCgc]/,'').length.to_f / nucleotides.length * 100
  end

end
