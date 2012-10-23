require 'genomer'
require 'genomer-plugin-summary/format'

class GenomerPluginSummary::Gaps < Genomer::Plugin
  include GenomerPluginSummary::Format

  def run
    tabulate determine_gaps scaffold
  end

  COLUMNS    = [:number,  :length,  :start,  :end,  :type]

  FORMATTING = {
    :title   => 'Scaffold Gaps',
    :headers => ['Number', 'Length', 'Start', 'End', 'Type'],
    :width   => {
      0 => 8,
      1 => 8,
      2 => 8,
      3 => 8,
      4 => 12
    },
    :justification   => {
      0 => :right,
      1 => :right,
      2 => :right,
      3 => :right,
      4 => :center
    }
  }

  def tabulate(contigs)
    table(contigs.map{|ctg| COLUMNS.map{|col| ctg[col]}},FORMATTING)
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
