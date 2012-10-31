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

  def enumerator_for_contig(scaffold)
    genome = scaffold.mapping(&:sequence).to_a.join
    regions = genome.
      gsub(/([^Nn])([Nn])/,'\1 \2').
      gsub(/([Nn])([^Nn])/,'\1 \2').
      scan(/[^\s]+/)

    regions.inject([0,1,[]]) do |memo,entry|
      position, number, entries = memo

      if entry.downcase.include? 'n'
        next [position + entry.length, number, entries]
      end

      i = {:sequence => entry,
           :start    => position + 1,
           :stop     => position + entry.length,
           :type     => :contig,
           :id       => number}

      [position + entry.length, number + 1, entries << i]
    end.last
  end

  def enumerator_for_gap(scaffold)
    genome = scaffold.mapping(&:sequence).to_a.join
    regions = genome.
      gsub(/([^Nn])([Nn])/,'\1 \2').
      gsub(/([Nn])([^Nn])/,'\1 \2').
      scan(/[^\s]+/)

    regions.inject([0,1,[]]) do |memo,entry|
      position, number, entries = memo

      unless entry.downcase.include? 'n'
        next [position + entry.length, number, entries]
      end

      i = {:sequence => entry,
           :start    => position + 1,
           :stop     => position + entry.length,
           :type     => :gap,
           :id       => number}

      [position + entry.length, number + 1, entries << i]
    end.last
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
