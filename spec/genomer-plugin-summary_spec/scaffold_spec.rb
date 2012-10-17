require 'spec_helper'
require 'genomer-plugin-summary/scaffold'

describe GenomerPluginSummary::Scaffold do

  describe "#tabulate" do

    subject do
      described_class.new([],{}).tabulate(data) + "\n"
    end

    context "passed table data" do

      let(:data) do
        {:n_contigs  =>   1,
         :n_gaps     =>   0,
         :bp_size    =>   4,
         :bp_contigs =>   1,
         :bp_gaps    =>   0,
         :pc_gc      =>  50.0,
         :pc_contigs => 100.0,
         :pc_gaps    =>   0.0}
      end

      it do
        should ==<<-EOS.unindent!
      +--------------+-----------+
      |         Scaffold         |
      +--------------+-----------+
      | Contigs (#)  |         1 |
      | Gaps (#)     |         0 |
      +--------------+-----------+
      | Size (bp)    |         4 |
      | Contigs (bp) |         1 |
      | Gaps (bp)    |         0 |
      +--------------+-----------+
      | G+C (%)      |     50.00 |
      | Contigs (%)  |    100.00 |
      | Gaps (%)     |      0.00 |
      +--------------+-----------+
        EOS
      end
    end
  end

end
