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
      metric.gc_content entry_type, scaffold
    end

    context "an empty scaffold" do
      let(:scaffold){ [] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should be_nan }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == be_nan }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == be_nan }
      end

    end

    context "a single contig scaffold" do
      let(:scaffold){ [sequence('ATGC')] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 50.0 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should be_nan }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 50.0 }
      end

    end

    context "a mixed scaffold" do
      let(:scaffold){ [sequence('ATGC'),unresolved('NNNN'),sequence('ATGC')] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 50.0 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == be_nan }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 50.0 }
      end

    end

  end

  describe "#count" do

    subject do
      metric.count entry_type, scaffold
    end

    context "an empty scaffold" do
      let(:scaffold){ [] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 0 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == 0 }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 0 }
      end

    end

    context "a single contig scaffold" do
      let(:scaffold){ [sequence('ATGC')] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 1 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == 0 }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 1 }
      end

    end

    context "a mixed scaffold" do
      let(:scaffold){ [sequence('ATGC'),unresolved('NNNN'),sequence('ATGC')] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 2 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == 1 }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 3 }
      end

    end

  end

  describe "#length" do

    subject do
      metric.length entry_type, scaffold
    end

    context "an empty scaffold" do
      let(:scaffold){ [] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 0 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == 0 }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 0 }
      end

    end

    context "a single contig scaffold" do
      let(:scaffold){ [sequence('ATGC')] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 4 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == 0 }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 4 }
      end
    end

    context "a mixed scaffold" do
      let(:scaffold){ [sequence('ATGC'),unresolved('NNNN'),sequence('ATGC')] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 8 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == 4 }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 12 }
      end
    end

  end

  describe "#percent" do

    subject do
      metric.percent entry_type, scaffold
    end

    context "an empty scaffold" do
      let(:scaffold){ [] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should be_nan }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == be_nan }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == be_nan }
      end

    end

    context "a single contig scaffold" do
      let(:scaffold){ [sequence('ATGC')] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 100.0 }
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == 0.0 }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 100.0 }
      end
    end

    context "a mixed scaffold" do
      let(:scaffold){ [sequence('ATGC'),unresolved('NNNN'),sequence('ATGC')] }

      context "contigs" do
        let(:entry_type){ :sequence }
        it{ should == 8 / 12.0 * 100}
      end
      context "gaps" do
        let(:entry_type){ :unresolved }
        it{ should == 4 / 12.0 * 100 }
      end
      context "everything" do
        let(:entry_type){ :all }
        it{ should == 100.0 }
      end
    end

  end

end
