require 'spec_helper'
require 'genomer-plugin-summary/scaffold'

describe GenomerPluginSummary::Scaffold do

  describe "#tabulate" do

    subject do
      described_class.new([],{}).tabulate(data) + "\n"
    end

    context "passed table data" do

      let(:data) do
        [['Contigs (#)',1.0],
          :separator,
         ['Gaps (#)',0]]
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
