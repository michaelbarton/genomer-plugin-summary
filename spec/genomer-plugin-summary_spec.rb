require 'spec_helper'

describe GenomerPluginSummary do

  example = described_class::Example = Class.new(described_class)

  before do
    mock(described_class).require 'genomer-plugin-summary/example'
  end

  describe "#fetch" do

    it "should return the required view plugin class" do
      described_class.fetch('example').should == example
    end

  end

  describe "#run" do

    it "should initialize and run the required summary plugin" do
      mock.proxy(example).new([:arg],:flags) do |instance|
        mock(instance).run
      end

      described_class.new(['example',:arg],:flags).run
    end

  end

end
