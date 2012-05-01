require 'spec_helper'
require 'genomer-plugin-summary/gaps'

describe GenomerPluginSummary::Gaps do

  describe "#tabulate" do

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

  describe "#determine_gaps" do

    def sequence(seq)
      s = mock!
      stub(s).sequence{ seq }
      s
    end

    subject do
      described_class.new([],{}).determine_gaps(scaffold)
    end

    context "an empty scaffold" do
      let(:scaffold) do
        []
      end

      it{ should == []}
    end

    context "a scaffold with a single contig" do
      let(:scaffold) do
        [sequence('AAATTT')]
      end

      it{ should == []}
    end

    context "a scaffold with a single contig containing a gap" do
      let(:scaffold) do
        [sequence('AANNTT')]
      end

      it do
        should == [{:number => 1, :length => 2, :start => 3, :end => 4, :type => :contig}]
      end
    end

    context "a scaffold with a two contigs containing gaps" do
      let(:scaffold) do
        [sequence('AANNTT'), sequence('AANNTT')]
      end

      it do
        should == [
          {:number => 1, :length => 2, :start => 3,  :end => 4,  :type => :contig},
          {:number => 2, :length => 2, :start => 9, :end => 10, :type => :contig}]
      end
    end

  end

  describe "#gap_locations" do

    subject do
      described_class.new([],{}).gap_locations(sequence)
    end

    context "an empty string" do
      let(:sequence){ "" }
      it{ should == []}
    end

    context "a sequence with no gaps" do
      let(:sequence){ "ATGC" }
      it{ should == []}
    end

    context "a sequence with a single gap" do
      let(:sequence){ "ATGCNNNATGC" }
      it{ should == [5..7]}
    end

    context "a sequence with a single character gap" do
      let(:sequence){ "ANC" }
      it{ should == [2..2]}
    end

    context "a sequence with two gaps" do
      let(:sequence){ "ATGCNNNATGCNNNNATGC" }
      it{ should == [5..7, 12..15]}
    end

  end

end
