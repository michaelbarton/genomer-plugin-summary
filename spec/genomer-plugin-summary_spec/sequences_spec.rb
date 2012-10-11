require 'spec_helper'
require 'genomer-plugin-summary/sequences'

describe GenomerPluginSummary::Sequences do

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
      +--------------+------------+------------+------------+----------+--------+
      |                           Scaffold Sequences                            |
      +--------------+------------+------------+------------+----------+--------+
      | Sequence     | Start (bp) |  End (bp)  | Size (bp)  | Size (%) | GC (%) |
      +--------------+------------+------------+------------+----------+--------+
      +--------------+------------+------------+------------+----------+--------+
      | Scaffold     |         NA |         NA |         NA |       NA |     NA |
      +--------------+------------+------------+------------+----------+--------+
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

  end

end
