require 'genomer'
require 'lazing'

module GenomerPluginSummary::Metrics

  ALL = :all

  def gc_content(type,scfd)
    gc   = enumerator_for(type,scfd).mapping{|i|   gc(i)}.inject(:+) || 0.0
    atgc = enumerator_for(type,scfd).mapping{|i| atgc(i)}.inject(:+) || 0.0
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
      mapping(&:sequence).
      mapping(&:length).
      inject(:+) || 0
  end

  def gc(entry)
    entry.sequence.gsub(/[^GCgc]/,'').length.to_f
  end

  def atgc(entry)
    entry.sequence.gsub(/[^ATGCatgc]/,'').length.to_f
  end

  def enumerator_for(type,scaffold)
    scaffold.selecting{|i| [ALL,i.entry_type].include? type }
  end

end
