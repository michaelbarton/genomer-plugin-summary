require 'spec_helper'
require 'genomer-plugin-summary/sequences'

describe GenomerPluginSummary::Sequences do

  def row(name,start,stop,percent,gc)
    {:sequence => name,
     :start    => start,
     :end      => stop,
     :size     => (stop - start) + 1,
     :percent  => percent,
     :gc       => gc}
  end

  describe "#tabulate" do

    subject do
      described_class.new([],{}).tabulate(sequences,total) + "\n"
    end

    context "passed an empty array" do

      let(:sequences) do
        []
      end

      let(:total) do
        {:start   => 'NA',
         :end     => 'NA',
         :size    => 'NA',
         :percent => 'NA',
         :gc      => 'NA' }
      end

      it do
        should ==<<-EOS.unindent!
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      | Sequence         | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      +------------------+------------+------------+------------+----------+--------+
      | Scaffold         |         NA |         NA |         NA |       NA |     NA |
      +------------------+------------+------------+------------+----------+--------+
        EOS
      end

    end

    context "passed an array with a single row" do

      let(:sequences) do
        [{:sequence   => 'contig1',
          :start      => '1',
          :end        => '4',
          :size       => '4',
          :percent    => 100.0,
          :gc         => 50.0 }]
      end

      let(:total) do
        {:start   => '1',
         :end     => '4',
         :size    => '4',
         :percent => 100.0,
         :gc      => 50.0 }
      end

      it do
        should ==<<-EOS.unindent!
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      | Sequence         | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig1          |          1 |          4 |          4 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      | Scaffold         |          1 |          4 |          4 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
        EOS
      end

    end

    context "passed a array with two rows" do

      let(:sequences) do
        [{:sequence   => 'contig1',
          :start      => '1',
          :end        => '4',
          :size       => '4',
          :percent    => 100.0,
          :gc         => 50.0 },
         {:sequence   => 'contig2',
          :start      => '1',
          :end        => '4',
          :size       => '4',
          :percent    => 100.0,
          :gc         => 50.0 }]
      end

      let(:total) do
        {:start   => '1',
         :end     => '4',
         :size    => '4',
         :percent => 100.0,
         :gc      => 50.0 }
      end

      it do
        should ==<<-EOS.unindent!
      +------------------+------------+------------+------------+----------+--------+
      |                             Scaffold Sequences                              |
      +------------------+------------+------------+------------+----------+--------+
      | Sequence         | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +------------------+------------+------------+------------+----------+--------+
      | contig1          |          1 |          4 |          4 |   100.00 |  50.00 |
      | contig2          |          1 |          4 |          4 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
      | Scaffold         |          1 |          4 |          4 |   100.00 |  50.00 |
      +------------------+------------+------------+------------+----------+--------+
        EOS
      end

    end

  end

  describe "#calculate" do

    subject do
      described_class.new([],{}).calculate(scaffold)
    end

    context "passed an empty array" do
      let(:scaffold) do
        []
      end

      it do
        should == []
      end
    end

    context "passed one sequence" do
      let(:scaffold) do
        [sequence('AAAGGG','contig1')]
      end

      it do
        should == [row('contig1',1,6,100.0,50.0)]
      end
    end

    context "passed two sequences" do
      let(:scaffold) do
        [sequence('AAAGGG','contig1'),
         sequence('AAAGGG','contig2')]
      end

      it do
        should == [row('contig1', 1,  6, 50.0, 50.0),
                   row('contig2', 7, 12, 50.0, 50.0)]
      end
    end

    context "passed two sequences separated by a gap" do
      let(:scaffold) do
        [sequence('AAAGGG','contig1'),
         unresolved('NNNNNNNN'),
         sequence('AAAGGG','contig2')]
      end

      it do
        should == [row('contig1', 1,  6,  30.0, 50.0),
                   row('contig2', 15, 20, 30.0, 50.0)]
      end
    end

  end

  describe "#total" do

    subject do
      described_class.new([],{}).total(sequences)
    end

    context "passed an empty array" do
      let(:sequences) do
        []
      end

      it do
        should == {
          :start   => 'NA',
          :end     => 'NA',
          :size    => 'NA',
          :percent => 'NA',
          :gc      => 'NA' }
      end
    end

    context "passed one entry" do
      let(:sequences) do
        [row('contig1',1,6,100.0,50.0)]
      end

      it do
        should == {
          :start   => 1,
          :end     => 6,
          :size    => 6,
          :percent => 100.0,
          :gc      => 50.0 }
      end
    end

    context "passed two entries less than 100% of the scaffold" do
      let(:sequences) do
        [row('contig1', 1,  6,  30.0, 50.0),
         row('contig2', 15, 20, 30.0, 50.0)]
      end

      it do
        should == {
          :start   => 1,
          :end     => 20,
          :size    => 12,
          :percent => 60.0,
          :gc      => 50.0 }
      end
    end
  end

end
