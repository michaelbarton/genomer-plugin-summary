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

  COLUMNS    = [:id, :start, :stop, :size, :percent, :gc]

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
    total_length   = scaffold.mapping(&:sequence).mapping(&:length).inject(&:+).to_f

    enumerator_for(:sequence,scaffold).mapping do |entry|
      sequence = entry.delete(:sequence)

      entry[:size]    = sequence.length
      entry[:gc]      = gc(sequence) / atgc(sequence) * 100
      entry[:percent] = sequence.length / total_length * 100
      entry
    end.to_a
  end

  def total(seqs)
    return Hash[[:start, :stop, :size, :percent, :gc].map{|i| [i, 0]}] if seqs.empty?

    totals = seqs.inject({:size => 0, :percent => 0, :gc => 0}) do |hash,entry|
      hash[:start]  ||= entry[:start]
      hash[:stop]     = entry[:stop]
      hash[:size]    += entry[:size]
      hash[:percent] += entry[:percent]
      hash[:gc]      += entry[:gc] * entry[:size]

      hash
    end
    totals[:gc] /= totals[:size]
    totals
  end

end
