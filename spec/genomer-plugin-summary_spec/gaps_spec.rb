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
        [Sequence.new(:sequence => 'AAATTT')]
      end

      it{ should == []}
    end

    context "a scaffold with a single contig containing a gap" do
      let(:scaffold) do
        [Sequence.new(:sequence => 'AAANNNNTTT')]
      end

      it do
        should == [{:number => 1, :length => 4, :start => 4, :end => 8, :type => :contig}]
      end
    end

    context "a scaffold with a two contigs containing gaps" do
      let(:scaffold) do
        [Sequence.new(:sequence => 'AAANNNNTTT'),Sequence.new(:sequence => 'AAANNNNTTT')]
      end

      it do
        should == [
          {:number => 1, :length => 4, :start => 4,  :end => 8,  :type => :contig},
          {:number => 2, :length => 4, :start => 14, :end => 18, :type => :contig}]
      end
    end

    context "a scaffold with two contigs separated by an unresolved region" do
      let(:scaffold) do
        [Sequence.new(:sequence => 'AAA'),
         Unresolved.new(:length => 10),
         Sequence.new(:sequence => 'AAA')]
      end

      it do
        should == [
          {:number => 1, :length => 10, :start => 4,  :end => 14,  :type => :unresolved}]
      end
    end

    context "a scaffold with a mixture of gapped contigs and unresolved regions" do
      let(:scaffold) do
        [Sequence.new(:sequence => 'AAANNNTTT'),
         Unresolved.new(:length => 10),
         Sequence.new(:sequence => 'AAANT'),
         Unresolved.new(:length => 10),
        ]
      end

      it do
        should == [
          {:number => 1, :length => 3,  :start => 4,   :end => 6,  :type => :contig},
          {:number => 2, :length => 10, :start => 10,  :end => 19, :type => :unresolved},
          {:number => 3, :length => 1,  :start => 23,  :end => 23, :type => :contig},
          {:number => 4, :length => 10, :start => 25,  :end => 34, :type => :unresolved}]
      end
    end

  end

end
