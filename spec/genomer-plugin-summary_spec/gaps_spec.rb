require 'spec_helper'
require 'genomer-plugin-summary/gaps'

describe GenomerPluginSummary::Gaps do

  describe "tabulate" do

    subject do
      described_class.new([],{}).tabulate(contigs).to_s + "\n"
    end

    context "passed an empty array" do

      let(:contigs) do
        []
      end

      it do
        should ==<<-EOS.unindent!
          +----------+----------+----------+----------+--------------+
          |                      Scaffold Gaps                       |
          +----------+----------+----------+----------+--------------+
          |  Number  |  Length  |  Start   |   End    |     Type     |
          +----------+----------+----------+----------+--------------+
          +----------+----------+----------+----------+--------------+
        EOS
      end

    end

    context "passed an array with one entry" do

      let(:contigs) do
        [{:number => 1, :length => 1, :start => 1, :end => 1, :type => :contig}]
      end

      it do
        should ==<<-EOS.unindent!
          +----------+----------+----------+----------+--------------+
          |                      Scaffold Gaps                       |
          +----------+----------+----------+----------+--------------+
          |  Number  |  Length  |  Start   |   End    |     Type     |
          +----------+----------+----------+----------+--------------+
          |        1 |        1 |        1 |        1 |    contig    |
          +----------+----------+----------+----------+--------------+
        EOS
      end

    end

    context "passed an array with two entries" do

      let(:contigs) do
        [{:number => 1, :length => 1, :start => 1, :end => 1, :type => :contig},
         {:number => 2, :length => 2, :start => 2, :end => 2, :type => :unresolved}]
      end

      it do
        should ==<<-EOS.unindent!
          +----------+----------+----------+----------+--------------+
          |                      Scaffold Gaps                       |
          +----------+----------+----------+----------+--------------+
          |  Number  |  Length  |  Start   |   End    |     Type     |
          +----------+----------+----------+----------+--------------+
          |        1 |        1 |        1 |        1 |    contig    |
          |        2 |        2 |        2 |        2 |  unresolved  |
          +----------+----------+----------+----------+--------------+
        EOS
      end

    end

  end

end
