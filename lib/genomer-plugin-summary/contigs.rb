require 'genomer'
require 'genomer-plugin-summary/format'

class GenomerPluginSummary::Contigs < Genomer::Plugin
  include GenomerPluginSummary::Format

  FORMATTING = {
    :title   => 'Scaffold Contigs',
    :headers => ['Contig', 'Start (bp)', 'End (bp)', 'Size (bp)', 'Size (%)', 'GC (%)'],
    :width => {
      0 => 6,
      1 => 10,
      2 => 10,
      3 => 10,
      4 => 8,
      5 => 6
    },
    :justification => {
      0 => :right,
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
  COLUMNS = [:num, :start, :stop, :size, :percent, :gc]

  def tabulate(contigs,total,flags)
    rows = contigs.map{|contig| COLUMNS.map{|col| contig[col]}}.
      <<(:separator).
      <<(COLUMNS.map{|col| total[col] || 'All'})

    FORMATTING[:output] = flags[:output]
    table(rows,FORMATTING)
  end

end
