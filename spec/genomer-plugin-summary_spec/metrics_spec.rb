require 'spec_helper'
require 'genomer-plugin-summary/metrics'

describe GenomerPluginSummary::Metrics do

  let(:metric) do
   o = Object.new
   o.extend described_class
   o
  end

  describe "#gc_content" do

    subject do
      metric.gc_content sequence
    end

    context "an empty sequence" do

      let(:sequence) do
        ''
      end

      it do
        should be_nan
      end

    end

    context "a single sequence" do

      let(:sequence) do
        'ATGC'
      end

      it do
        should == 50.0
        should be_instance_of Float
      end

    end

    context "a mixed case sequence" do

      let(:sequence) do
        'ATGCgggg'
      end

      it do
        should == 75.0
        should be_instance_of Float
      end

    end

    context "a sequence containing N" do

      let(:sequence) do
        'ATGCNN'
      end

      it do
        should == 50.0
        should be_instance_of Float
      end

    end

  end

end
