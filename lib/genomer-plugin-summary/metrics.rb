require 'genomer'

module GenomerPluginSummary::Metrics

  def gc_content(sequence)
    nucleotides = sequence.gsub(/[^ATGCatgc]/,'')
    nucleotides.gsub(/[^GCgc]/,'').length.to_f / nucleotides.length * 100
  end

end
