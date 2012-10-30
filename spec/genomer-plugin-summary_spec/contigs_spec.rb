require 'spec_helper'
require 'genomer-plugin-summary/contigs'

describe GenomerPluginSummary::Contigs do

  def row(num,start,stop,percent,gc)
    {:num      => num,
     :start    => start,
     :stop     => stop,
     :size     => (stop - start) + 1,
     :percent  => percent,
     :gc       => gc}
  end

  describe "#tabulate" do

    subject do
      described_class.new([],{}).tabulate(contigs,total,flags)
    end

    let(:flags) do
      {}
    end

    context "passed an empty array" do

      let(:contigs) do
        []
      end

      let(:total) do
        {:start   => 0,
         :stop    => 0,
         :size    => 0,
         :percent => 0,
         :gc      => 0 }
      end

      it do
        should ==<<-EOS.unindent!
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      +--------+------------+------------+------------+----------+--------+
      |    All |          0 |          0 |          0 |     0.00 |   0.00 |
      +--------+------------+------------+------------+----------+--------+
        EOS
      end

    end

    context "passed an array with a single row" do

      let(:contigs) do
        [row(1,1,4,100.0,50.0)]
      end

      let(:total) do
        {:start   => '1',
         :stop    => '4',
         :size    => '4',
         :percent => 100.0,
         :gc      => 50.0 }
      end

      it do
        should ==<<-EOS.unindent!
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |          4 |          4 |   100.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |          4 |          4 |   100.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
        EOS
      end

    end

    context "passed a array with two rows" do

      let(:contigs) do
        [row(1,1,4,100.0,50.0),
         row(2,1,4,100.0,50.0)]
      end

      let(:total) do
        {:start   => '1',
         :stop    => '4',
         :size    => '4',
         :percent => 100.0,
         :gc      => 50.0 }
      end

      it do
        should ==<<-EOS.unindent!
      +--------+------------+------------+------------+----------+--------+
      |                         Scaffold Contigs                          |
      +--------+------------+------------+------------+----------+--------+
      | Contig | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------+------------+------------+------------+----------+--------+
      |      1 |          1 |          4 |          4 |   100.00 |  50.00 |
      |      2 |          1 |          4 |          4 |   100.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
      |    All |          1 |          4 |          4 |   100.00 |  50.00 |
      +--------+------------+------------+------------+----------+--------+
        EOS
      end

    end

    context "passed the csv output option" do

      let(:flags) do
        {:output => 'csv'}
      end

      let(:contigs) do
        [row(1,1,4,100.0,50.0),
         row(2,1,4,100.0,50.0)]
      end

      let(:total) do
        {:start   => '1',
         :stop    => '4',
         :size    => '4',
         :percent => 100.0,
         :gc      => 50.0 }
      end

      it do
        should ==<<-EOS.unindent!
          contig,start_bp,end_bp,size_bp,size_%,gc_%
          1,1,4,4,100.00,50.00
          2,1,4,4,100.00,50.00
          all,1,4,4,100.00,50.00
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
        should == [row(1,1,6,100.0,50.0)]
      end
    end

    context "passed two sequences" do
      let(:scaffold) do
        [sequence('AAAGGG','contig1'),
         sequence('AAAGGG','contig2')]
      end

      it do
        should == [row(1, 1,  6, 50.0, 50.0),
                   row(2, 7, 12, 50.0, 50.0)]
      end
    end

    context "passed two sequences separated by a gap" do
      let(:scaffold) do
        [sequence('AAAGGG','contig1'),
         unresolved('NNNNNNNN'),
         sequence('AAAGGG','contig2')]
      end

      it do
        should == [row(1, 1,  6,  30.0, 50.0),
                   row(2, 15, 20, 30.0, 50.0)]
      end
    end

    context "passed one contig containing a gap" do
      let(:scaffold) do
        [sequence('AAAGGGNNNNNNNNAAAGGG','contig1')]
      end

      it do
        should == [row(1, 1,  6,  30.0, 50.0),
                   row(2, 15, 20, 30.0, 50.0)]
      end
    end

  end
end
