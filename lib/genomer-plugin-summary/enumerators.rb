require 'lazing'

module GenomerPluginSummary::Enumerators

  def enumerator_for(type,scaffold)
    send('enumerator_for_' + type.to_s, scaffold)
  end

  def enumerator_for_sequence(scaffold)
    enumerator_for_all(scaffold).
      selecting{|i| i[:type] == :sequence}
  end

  def enumerator_for_unresolved(scaffold)
    enumerator_for_all(scaffold).
      selecting{|i| i[:type] == :unresolved}
  end

  def enumerator_for_all(scaffold)
    scaffold.inject([0,[]]) do |memo,entry|
      position, entries = memo

      i = {:sequence   => entry.sequence,
           :start      => position + 1,
           :stop       => position + entry.sequence.length,
           :type       => entry.entry_type,
           :id         => entry.entry_type == :sequence ? entry.source : nil} 

      [position + entry.sequence.length, entries << i]
    end.last
  end

end
