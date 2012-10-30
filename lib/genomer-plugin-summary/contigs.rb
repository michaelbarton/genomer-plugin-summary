require 'genomer'
require 'genomer-plugin-summary/format'
require 'genomer-plugin-summary/enumerators'
require 'genomer-plugin-summary/metrics'

class GenomerPluginSummary::Contigs < Genomer::Plugin
  include GenomerPluginSummary::Metrics
  include GenomerPluginSummary::Format
  include GenomerPluginSummary::Enumerators

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

  def run
    contigs = calculate(scaffold)
    total   = sequence_total(contigs)

    tabulate(contigs,total,flags)
  end

  def tabulate(contigs,total,flags)
    rows = contigs.map{|contig| COLUMNS.map{|col| contig[col]}}.
      <<(:separator).
      <<(COLUMNS.map{|col| total[col] || 'All'})

    FORMATTING[:output] = flags[:output]
    table(rows,FORMATTING)
  end

  def calculate(scaffold)
    total_length = scaffold.mapping(&:sequence).mapping(&:length).inject(&:+).to_f
    contig_no    = 0
    position     = 1

    enumerator_for_all(scaffold).mapping do |s|
      regions = s[:sequence].
        gsub(/([^Nn])([Nn])/,'\1 \2').
        gsub(/([Nn])([^Nn])/,'\1 \2').
        scan(/[^\s]+/)

      regions.inject([]) do |contigs, region|
        unless region.downcase.include? 'n'
          contigs <<(
            {
            :num     => contig_no += 1,
            :start   => position,
            :stop    => position + region.length - 1,
            :size    => region.length,
            :percent => region.length / total_length * 100,
            :gc      => gc(region) / atgc(region) * 100
            }
          )
        end
        position += region.length
        contigs
      end
    end.to_a.flatten
  end

end
