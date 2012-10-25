require 'genomer'
require 'genomer-plugin-summary/metrics'
require 'genomer-plugin-summary/format'

class GenomerPluginSummary::Sequences < Genomer::Plugin
  include GenomerPluginSummary::Metrics
  include GenomerPluginSummary::Format
  include GenomerPluginSummary::Enumerators

  def run
    sequences = calculate(scaffold)
    total     = total(sequences)

    tabulate(sequences,total,flags)
  end

  COLUMNS    = [:sequence, :start, :end, :size, :percent, :gc]

  FORMATTING = {
    :title   => 'Scaffold Sequences',
    :headers => ['Sequence', 'Start (bp)', 'End (bp)', 'Size (bp)', 'Size (%)', 'GC (%)'],
    :width => {
      0 => 16,
      1 => 10,
      2 => 10,
      3 => 10,
      4 => 8,
      5 => 6
    },
    :justification => {
      0 => :left,
      1 => :right,
      2 => :right,
      3 => :right,
      4 => :right,
      5 => :right
    },
    :format => {
      4 => '%#.2f',
      5 => '%#.2f'
    }
  }

  def tabulate(sequences,total,flags)
    rows = sequences.map{|sequence| COLUMNS.map{|col| sequence[col]}}.
      <<(:separator).
      <<(COLUMNS.map{|col| total[col] || 'All'})

    FORMATTING[:output] = flags[:output]
    table(rows,FORMATTING)
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
              :gc       => gc(entry.sequence) / atgc(entry.sequence) * 100 }
      end
        
      running_length += entry.sequence.length
      i
    end.compact
  end

  def total(seqs)
    return Hash[[:start, :end, :size, :percent, :gc].map{|i| [i, 0]}] if seqs.empty?

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
