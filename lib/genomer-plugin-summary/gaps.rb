require 'genomer'
require 'terminal-table'

class GenomerPluginSummary::Gaps < Genomer::Plugin

  def run
    tabulate determine_gaps scaffold
  end

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

    table.to_s
  end

  def gap_locations(seq)
    seq.upcase.enum_for(:scan, /(N+)/).map do
      (Regexp.last_match.begin(0)+1)..(Regexp.last_match.end(0))
    end
  end

  def determine_gaps(scaffold)
    count  = 0
    length = 0

    scaffold.map do |entry|
      gaps = case entry.entry_type
             when :sequence then
               gap_locations(entry.sequence).map do |gap|
                 count += 1
                 {:number => count,
                  :length => (gap.end - gap.begin) + 1,
                  :start  => gap.begin + length,
                  :end    => gap.end   + length,
                  :type   => :contig}
               end
             when :unresolved then
               count += 1
               {:number => count,
                :length => entry.sequence.length,
                :start  => length + 1,
                :end    => length + entry.sequence.length,
                :type   => :unresolved}
             end
      length += entry.sequence.length
      gaps
    end.flatten
  end

end
