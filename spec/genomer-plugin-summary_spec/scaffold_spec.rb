require 'spec_helper'
require 'genomer-plugin-summary/scaffold'

describe GenomerPluginSummary::Scaffold do

  describe "#tabulate" do

    subject do
      described_class.new([],{}).tabulate(data,flags)
    end

    let(:data) do
      [['Contigs (#)',1.0],
        :separator,
          ['Gaps (#)',0]]
    end

    context "passed table data" do

      let(:flags) do
        {}
      end

      it do
        should ==<<-EOS.unindent!
      +--------------+-----------+
      |         Scaffold         |
      +--------------+-----------+
      | Contigs (#)  |      1.00 |
      +--------------+-----------+
      | Gaps (#)     |         0 |
      +--------------+-----------+
        EOS
      end

    end

    context "passed table with the format option" do

      let(:flags) do
        {:output => 'csv'}
      end

      it do
        should ==<<-EOS.unindent!
          contigs_#,1.00
          gaps_#,0
        EOS
      end
    end
  end

  describe "#calculate_metrics" do

    subject do
      described_class.new([],{}).calculate_metrics(specs,scaffold)
    end

    context "should calculate a single metrics for the scaffold" do

      let(:scaffold) do
        [sequence('ATGC')]
      end

      let(:specs) do
        [{:name => 'Contigs (%)',  :entry_type => :sequence,   :method => :percent}]
      end

      it do
        should == [['Contigs (%)',100.0]]
      end
    end

    context "should calculate a single metrics with separators" do

      let(:scaffold) do
        [sequence('ATGC')]
      end

      let(:specs) do
        [:separator,
         {:name => 'Contigs (%)',  :entry_type => :sequence,   :method => :percent}]
      end

      it do
        should == [
          :separator,
          ['Contigs (%)',100.0]
        ]
      end
    end

  end

end
