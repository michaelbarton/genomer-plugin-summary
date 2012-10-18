require 'genomer'
require 'lazing'

module GenomerPluginSummary::Metrics

  ALL = :all

  def gc_content(sequence)
    nucleotides = sequence.gsub(/[^ATGCatgc]/,'')
    nucleotides.gsub(/[^GCgc]/,'').length.to_f / nucleotides.length * 100
  end

  def count(type,scfd)
    enumerator_for(type,scfd).count
  end

  def percent(type,scfd)
    length(type,scfd) / length(ALL,scfd).to_f * 100
  end

  def length(type,scfd)
    enumerator_for(type,scfd).
      mapping(&:sequence).
      mapping(&:length).
      inject(:+) || 0
  end

  def enumerator_for(type,scaffold)
    scaffold.selecting{|i| [ALL,i.entry_type].include? type }
  end

end
