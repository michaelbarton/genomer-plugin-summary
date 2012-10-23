require 'spec_helper'
require 'genomer-plugin-summary/format'

describe GenomerPluginSummary::Format do

  subject do
    o = Object.new
    o.extend described_class
    o.send(method,data,options)
  end

  describe "#table" do

    let(:method){ :table }

    let(:data) do
      [['Contigs (#)',1.0],
        :separator,
        ['Gaps (#)',0]]
    end

    context "passed data without any options" do

      let(:options) do
        {}
      end

      it do
        should ==<<-EOS.unindent!
      +-------------+-----+
      | Contigs (#) | 1.0 |
      +-------------+-----+
      | Gaps (#)    | 0   |
      +-------------+-----+
        EOS
      end
    end

    context "passed data with a header option" do

      let(:options) do
        {:title => 'Scaffold' }
      end

      it do
        should ==<<-EOS.unindent!
      +-------------+-----+
      |     Scaffold      |
      +-------------+-----+
      | Contigs (#) | 1.0 |
      +-------------+-----+
      | Gaps (#)    | 0   |
      +-------------+-----+
        EOS
      end

    end

    context "passed data with justification options" do

      let(:options) do
        {:justification => {
          0 => :left,
          1 => :right
        }}
      end

      it do
        should ==<<-EOS.unindent!
      +-------------+-----+
      | Contigs (#) | 1.0 |
      +-------------+-----+
      | Gaps (#)    |   0 |
      +-------------+-----+
        EOS
      end
    end

    context "passed a width option" do

      let(:options) do
        {:width         => { 0 => 15, 1 => 10 },
         :justification => { 1 => :right }}
      end

      it do
        should ==<<-EOS.unindent!
      +-----------------+------------+
      | Contigs (#)     |        1.0 |
      +-----------------+------------+
      | Gaps (#)        |          0 |
      +-----------------+------------+
        EOS
      end

    end

    context "passed a format option" do

      let(:options) do
        {:format => { 1 => '%#.2f'}}
      end

      it do
        should ==<<-EOS.unindent!
      +-------------+------+
      | Contigs (#) | 1.00 |
      +-------------+------+
      | Gaps (#)    | 0.00 |
      +-------------+------+
        EOS
      end

    end

    context "passed a header option" do

      let(:options) do
        {:headers => ['One','Two']}
      end

      it do
        should ==<<-EOS.unindent!
      +-------------+-----+
      |     One     | Two |
      +-------------+-----+
      | Contigs (#) | 1.0 |
      +-------------+-----+
      | Gaps (#)    | 0   |
      +-------------+-----+
        EOS
      end

    end

    context "passed a header option with width but no data" do

      let(:options) do
        {:headers => ['One','Two'],
         :width   => { 0 => 15, 1 => 10 }}
      end

      let(:data) do
        []
      end

      it do
        should ==<<-EOS.unindent!
      +-----------------+------------+
      |       One       |    Two     |
      +-----------------+------------+
      +-----------------+------------+
        EOS
      end

    end

  end

end
