require 'genomer'
require 'genomer-plugin-summary/enumerators'
require 'lazing'

module GenomerPluginSummary::Metrics
  include GenomerPluginSummary::Enumerators

  ALL = :all

  def gc_content(type,scfd)
    gc   = enumerator_for(type,scfd).mapping{|i|   gc(i[:sequence])}.inject(:+) || 0.0
    atgc = enumerator_for(type,scfd).mapping{|i| atgc(i[:sequence])}.inject(:+) || 0.0
    gc / atgc * 100
  end

  def count(type,scfd)
    enumerator_for(type,scfd).count
  end

  def percent(type,scfd)
    length(type,scfd) / length(ALL,scfd).to_f * 100
  end

  def length(type,scfd)
    enumerator_for(type,scfd).
      mapping{|i| i[:sequence]}.
      mapping(&:length).
      inject(:+) || 0
  end

  def gc(sequence)
    sequence.gsub(/[^GCgc]/,'').length.to_f
  end

  def atgc(sequence)
    sequence.gsub(/[^ATGCatgc]/,'').length.to_f
  end

  def sequence_total(seqs)
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
