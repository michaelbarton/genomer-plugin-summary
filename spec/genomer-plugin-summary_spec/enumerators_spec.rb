require 'spec_helper'
require 'genomer-plugin-summary/enumerators'

describe GenomerPluginSummary::Enumerators do

  describe "#enumerator_for" do

    subject do
      o = Object.new
      o.extend described_class
      o.enumerator_for(type,scaffold).to_a
    end

    describe "sequence" do

      let(:type){ :sequence }

      context "with an empty scaffold" do

        let(:scaffold) do
          []
        end

        it do
          should == []
        end

      end

      context "with a single unresolved region" do

        let(:scaffold) do
          [unresolved('NNNN')]
        end

        it do
          should == []
        end

      end

      context "with a single sequence region" do

        let(:scaffold) do
          [sequence('ATGC','ctg1')]
        end

        it do
          should == [
            {:start     => 1,
              :stop     => 4,
              :id       => 'ctg1',
              :sequence => 'ATGC',
              :type     => :sequence}
          ]
        end

      end

      context "with two sequence regions" do

        let(:scaffold) do
          [sequence('ATGC','ctg1'),sequence('ATGC','ctg2')]
        end

        it do
          should == [
            { :start    => 1,
              :stop     => 4,
              :id       => 'ctg1',
              :sequence => 'ATGC',
              :type     => :sequence},
            { :start    => 5,
              :stop     => 8,
              :id       => 'ctg2',
              :sequence => 'ATGC',
              :type     => :sequence}
          ]
        end

      end

      context "with two sequence regions separated by a gap" do

        let(:scaffold) do
          [sequence('ATGC','ctg1'), unresolved('NNNN'), sequence('ATGC','ctg2')]
        end

        it do
          should == [
            { :start    => 1,
              :stop     => 4,
              :id       => 'ctg1',
              :sequence => 'ATGC',
              :type     => :sequence},
            { :start    => 9,
              :stop     => 12,
              :id       => 'ctg2',
              :sequence => 'ATGC',
              :type     => :sequence}
          ]
        end

      end

    end

    describe "contig" do

      let(:type){ :contig }

      context "with an empty scaffold" do

        let(:scaffold) do
          []
        end

        it do
          should == []
        end

      end

      context "with a single unresolved region" do

        let(:scaffold) do
          [unresolved('NNNN')]
        end

        it do
          should == []
        end

      end

      context "with a single sequence region" do

        let(:scaffold) do
          [sequence('ATGC','ctg1')]
        end

        it do
          should == [
            {:start    => 1,
             :stop     => 4,
             :id       => 1,
             :sequence => 'ATGC',
             :type     => :contig}
          ]
        end

      end

      context "with two sequence regions" do

        let(:scaffold) do
          [sequence('ATGC','ctg1'),sequence('ATGC','ctg2')]
        end

        it do
          should == [
            {:start    => 1,
             :stop     => 8,
             :id       => 1,
             :sequence => 'ATGCATGC',
             :type     => :contig}
          ]
        end

      end

      context "with two sequence regions separated by a gap" do

        let(:scaffold) do
          [sequence('ATGC','ctg1'), unresolved('NNNN'), sequence('ATGC','ctg2')]
        end

        it do
          should == [
            { :start    => 1,
              :stop     => 4,
              :id       => 1,
              :sequence => 'ATGC',
              :type     => :contig},
            { :start    => 9,
              :stop     => 12,
              :id       => 2,
              :sequence => 'ATGC',
              :type     => :contig}
          ]
        end

      end

      context "with two sequence regions, one containing a gap" do

        let(:scaffold) do
          [sequence('ATGCNNNNATGC','ctg1'), sequence('ATGC','ctg2')]
        end

        it do
          should == [
            { :start    => 1,
              :stop     => 4,
              :id       => 1,
              :sequence => 'ATGC',
              :type     => :contig},
            { :start    => 9,
              :stop     => 16,
              :id       => 2,
              :sequence => 'ATGCATGC',
              :type     => :contig}
          ]
        end

      end

    end

    describe "unresolved" do

      let(:type){ :unresolved }

      context "with an empty scaffold" do

        let(:scaffold) do
          []
        end

        it do
          should == []
        end

      end

      context "with a single unresolved region" do

        let(:scaffold) do
          [unresolved('NNNN')]
        end

        it do
          should == [
            { :start    => 1,
              :stop     => 4,
              :id       => nil,
              :sequence => 'NNNN',
              :type     => :unresolved},
          ]
        end

      end

      context "with a single sequence region" do

        let(:scaffold) do
          [sequence('ATGC','ctg1')]
        end

        it do
          should == []
        end

      end

      context "with two sequence regions separated by a gap" do

        let(:scaffold) do
          [sequence('ATGC','ctg1'), unresolved('NNNN'), sequence('ATGC','ctg2')]
        end

        it do
          should == [
            { :start    => 5,
              :stop     => 8,
              :id       => nil,
              :sequence => 'NNNN',
              :type     => :unresolved},
          ]
        end

      end

    end

  end

end
